class User < ApplicationRecord
  # 安全密码: 模型中调用该方法，会自动添加如下功能 (需要添加 bcrypt gem)
  # 1. 在数据库中的 password_digest 列存储安全的密码哈希值 (需要表中添加这个字段)
  # 2. 获得一对虚拟属性(模型中有/数据库没有)，password 和 password_confirmation，而且创建用户对象时会执行存在性验证和匹配验证
  # 3. 获得 authenticate 方法，如果密码正确，返回对应的用户对象，否则返回 false
  has_secure_password
  # 会为 auth_token 生成一段随机 token，可使用 user.regenerate_auth_token 重新生成 token
  has_secure_token :auth_token

  has_many :identities
  has_many :topics
  has_many :posts
  has_many :notifications
  has_and_belongs_to_many :mentioned_posts, class_name: 'Post', join_table: 'mentions'
  has_many :subscriptions
  has_many :subscribed_topics, -> { where(subscriptions: { status: 'subscribed' }) }, through: :subscriptions, source: :topic
  has_many :ignored_topics, -> { where(subscriptions: { status: 'ignored' }) }, through: :subscriptions, source: :topic
  has_many :reactions
  has_many :attachments

  mount_uploader :avatar, AvatarUploader

  after_commit :generate_default_avatar, on: [:create]

  enum role: {
    default: 0,
    admin: 1
  }

  USERNAME_REGEXP = /\A[a-zA-Z]\w+\z/

  DEFAULT_AVATAR_COLORS = %w(
    #007bff
    #6610f2
    #6f42c1
    #e83e8c
    #dc3545
    #fd7e14
    #ffc107
    #28a745
    #20c997
    #17a2b8
  )

  validates :name, :username, :email, presence: true
  validates :username, :email, uniqueness: { case_sensitive: false }
  validates :username, format: { with: USERNAME_REGEXP }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # ActiveSupport 提供的扩展，可为类属性定义类和实例对象两者的访问器
  mattr_accessor :verifier
  self.verifier = Rails.application.message_verifier('User')

  def password_reset_token
    self.class.verifier.generate(id, purpose: :password_reset, expires_in: 5.minutes)
  end

  def self.from_password_reset_token(token)
    find verifier.verify(token, purpose: :password_reset)
  end

  private

  # 生成头像，创建一个缩小的头像
  def generate_default_avatar
    temp_path = "#{Rails.root}/tmp/#{id}_default_avatar.png"
    system(*%W(convert -size 160x160 -annotate 0 #{username[0]} -fill white -pointsize 100 -gravity Center xc:#{DEFAULT_AVATAR_COLORS.sample} #{temp_path}))
    avatar.store!(File.open(temp_path))
    save
    FileUtils.rm temp_path
  end
end
