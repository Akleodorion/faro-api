class UsersController < ApplicationController

  def index
  # Effectuez la logique pour récupérer les utilisateurs en fonction des numéros de téléphone
  users_data = User.where(phone_number: params[:phone_numbers]).pluck(:phone_number, :username, :id)

  # Convertissez les résultats en une structure JSON si nécessaire
  @users = users_data.map { |phone, username, id| { phone_number: phone, username: username, user_id: id } }

  render json: @users
  end

  private

  def users_params
    params.permit(:phone_numbers)
  end
end
