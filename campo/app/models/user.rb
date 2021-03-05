class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token

  has_many :identities

  enum role: {
    default: 0,
    admin: 1
  }

  USERNAME_REGEXP = /\A[a-zA-Z]\w+\z/

  validates :name, :username, :email, presence: true
  validates :username, :email, uniqueness: { case_sensitive: false }
  validates :username, format: { with: USERNAME_REGEXP }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
