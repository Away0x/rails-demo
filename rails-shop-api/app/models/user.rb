class User < ApplicationRecord

  has_secure_password

  # 一个用户只能创建一个商铺，一个商铺只能被一个用户所有
  has_one :shop, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: /\w+@\w+\.{1}[a-zA-Z]{2,}/ }
	validates :password_digest, presence: true
	validates :role, inclusion: { in: [0, 1, 2], message: "role can be only in [0 1 2]" }

end
