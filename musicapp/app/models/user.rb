class User < ApplicationRecord
  before_create :downcase_email

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  has_secure_password

  private

  def downcase_email
    self.email = email.downcase
  end

end
