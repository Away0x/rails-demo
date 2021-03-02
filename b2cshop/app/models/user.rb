# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  attr_accessor :remember_token, :activation_token, :reset_token

  # BEGIN ================================ hooks ================================
  before_save :downcase_email
  before_create :create_activation_digest
  before_create :create_uuid
  # END ================================ hooks ================================

  # BEGIN ================================ validators ================================
  validate :validate_email_or_phone, on: :create
  validates :password, presence: { message: '密码不能为空' }, length: { minimum: 6, message: '密码不能小于 6 位' }, allow_nil: true
  # END ================================ validators ================================

  # BEGIN ================================ attr ================================
  def username
    email.blank? ? phone : email.split('@').first
  end

  # END ================================ attr ================================

  # BEGIN ================================ auth ================================
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  # attribute: remember | password | reset
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # END ================================ auth ================================

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase # 或 email.downcase!
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def create_uuid
      self.uuid = RandomCode.generate_token
    end

    def validate_email_or_phone
      if [email, phone].all? { |a| a.nil? }
        errors.add :base, '邮箱和手机号其中之一不能为空'
        false
      else
        if phone.nil?
          if email.blank?
            errors.add :email, '邮箱不能为空'
            false
          else
            unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(email)
              errors.add :email, '邮箱格式不正确'
              false
            end
          end
        else
          unless /\A(\+86|86)?1\d{10}\z/.match?(phone)
            self.errors.add :cellphone, '手机号格式不正确'
            false
          end

          # unless VerifyToken.available.find_by(cellphone: phone, token: token)
          #   errors.add :cellphone, '手机验证码不正确或者已过期'
          #   false
          # end
        end
      end
    end

end
