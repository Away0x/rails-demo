VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

class User < ApplicationRecord

  # 安全密码: 模型中调用该方法，会自动添加如下功能 (需要添加 bcrypt gem)
  # 1. 在数据库中的 password_digest 列存储安全的密码哈希值 (需要表中添加这个字段)
  # 2. 获得一对虚拟属性(模型中有/数据库没有)，password 和 password_confirmation，而且创建用户对象时会执行存在性验证和匹配验证
  # 3. 获得 authenticate 方法，如果密码正确，返回对应的用户对象，否则返回 false
  has_secure_password

  # before_save { email.downcase! } # 同下面代码的功能
  before_save do
    self.email = self.email.downcase # 保存前将 email 转换为小写
  end

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
            length: { minimum: 6 }

end
