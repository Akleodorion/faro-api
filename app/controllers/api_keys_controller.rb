class ApiKeysController < ApplicationController
  def get_api_key
    api_key = ENV['API_KEY']
    render json: { api_key: api_key }
  end
end
p