class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable


  has_many :events, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :members, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self


  def generate_password_token
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (reset_password_sent_at + 30.minutes) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  private

  def generate_token
    SecureRandom.hex(3)
  end
end
