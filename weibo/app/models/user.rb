class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :microposts, dependent: :destroy
  # User 模型与 Relationship 模型建立主动关系之后得到的方法简介
  # active_relationship.follower: 获取关注我的用户
  # active_relationship.followed: 获取我关注的用户
  # user.active_relationships.create(followed_id: other_user.id): 创建 user 发起的主动关系
  # user.active_relationships.create!(followed_id: other_user.id): 创建 user 发起的主动关系(失败时抛出异常)
  # user.active_relationships.build(followed_id: other_user.id): 构建 user 发起的主动关系对象
  has_many :active_relationships, class_name: "Relationship",
           foreign_key: "follower_id",
           dependent: :destroy # 删除用户时也要删除涉及这个用户的 "关系"
  has_many :passive_relationships, class_name: "Relationship",
           foreign_key: "followed_id",
           dependent: :destroy
  # 定义该关联后可使用以下方法
  # user.following.include?(other_user)
  # user.following.find(other_user)
  # user.following << other_user
  # user.following.delete(other_user)
  # user.following.include?(other_user)
  has_many :following, through: :active_relationships, source: :followed
  # 可以省略 followers 关联中的 source 参数
  # Rails 会把 "followers" 转换成单数 "follower"，然后查找名为 follower_id 的外键
  has_many :followers, through: :passive_relationships, source: :follower

  # 安全密码: 模型中调用该方法，会自动添加如下功能 (需要添加 bcrypt gem)
  # 1. 在数据库中的 password_digest 列存储安全的密码哈希值 (需要表中添加这个字段)
  # 2. 获得一对虚拟属性(模型中有/数据库没有)，password 和 password_confirmation，而且创建用户对象时会执行存在性验证和匹配验证
  # 3. 获得 authenticate 方法，如果密码正确，返回对应的用户对象，否则返回 false
  has_secure_password

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name,
            presence: true,
            length: { maximum: 50 }

  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  # uniqueness: { case_sensitive: false } # 唯一性校验大小写不敏感

  validates :password,
            presence: true,
            length: { minimum: 6 },
            allow_nil: true # 密码为 nil 时能通过存在性验证，可是会被 has_secure_password 方法的验证捕获，所以不会修改密码为 nil

  class << self
    # 返回指定字符串的哈希摘要
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # 返回一个随机令牌
    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 为了持久保存会话，在数据库中记住用户
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # 如果指定的令牌和摘要匹配，返回 true
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # 忘记用户 (失去持久会话)
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 激活账户
  # Activates an account.
  def activate
    # update_attribute(:activated,    true)
    # update_attribute(:activated_at, Time.zone.now)
    # 将两次数据库事务合并为一个
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 发送激活邮件
  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # 设置密码重设相关的属性
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # 发送密码重设邮件
  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # 密码重设邮件 已经发出超过两小时
  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # 微博动态流
  def feed
    # 先获取所有 following 的 id，再查询动态流
    # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #                 following_ids: following_ids, # 获取 following 的 id list
    #                 user_id: id)

    # 使用子查询获取微博动态流 (用户多时效率比上面的 sql 高)
    # following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    # Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)

    # 使用 join 方法输出动态流
    part_of_feed = "relationships.follower_id = :id or microposts.user_id = :id"
    Micropost.joins(user: :followers).where(part_of_feed, { id: id })
  end

  # 关注另一个用户
  def follow(other_user)
    following << other_user
  end

  # 取消关注另一个用户
  def unfollow(other_user)
    following.delete(other_user)
  end

  # 如果当前用户关注了指定的用户，返回 true
  def following?(other_user)
    following.include?(other_user)
  end

  private

  # 把电子邮件地址转换成小写
  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase # 或 email.downcase!
  end

  # 创建并赋值激活令牌和摘要
  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
