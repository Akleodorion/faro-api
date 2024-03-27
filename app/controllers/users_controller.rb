# frozen_string_literal: true

require 'securerandom'
# controleur des users
class UsersController < ApplicationController
  def index
    users_data = User.where(phone_number: params[:phone_numbers]).pluck(:phone_number, :username, :id)
    @users = users_data.map { |phone, username, id| { phone_number: phone, username:, user_id: id } }
    render json: @users
  end

  private

  def users_params
    params.permit(:phone_numbers)
  end
end
