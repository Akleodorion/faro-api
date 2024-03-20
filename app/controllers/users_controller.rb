require 'securerandom'

class UsersController < ApplicationController

  def index
  # Effectuez la logique pour récupérer les utilisateurs en fonction des numéros de téléphone
  users_data = User.where(phone_number: params[:phone_numbers]).pluck(:phone_number, :username, :id)

  # Convertissez les résultats en une structure JSON si nécessaire
  @users = users_data.map { |phone, username, id| { phone_number: phone, username: username, user_id: id } }

  render json: @users
  end

  def generate_password_token!
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

  def users_params
    params.permit(:phone_numbers)
  end

  def generate_token
    SecureRandom.hex(5)
  end
end
