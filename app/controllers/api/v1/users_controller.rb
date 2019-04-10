class Api::V1::UsersController < ApplicationController
  skip_before_action :auth!, only: %i(create social_network)

  def create
    @user = User.new(user_params)

    if @user.save
      response.headers['auth_token'] = @user.generate_token

      render  json: { user: @user }
    else
      render  json: { errors: @user.errors }, status: 400
    end
  end

  def social_network
    sn_params.detect do |key, value|
      @data = case key
      when "facebook" then ::Providers::Facebook.get_data(value)
      when "google" then ::Providers::Google.get_data(value)
      end
    end
    user = User.where(email: @data["email"], facebook_id: @data["id"]).first_or_create!(password: SecureRandom.uuid)
    response.headers["Auth-token"] = user&.generate_token
    
    render json: {user: user}
  end

  def my_profile
    render json: current_user
  end

  private

  def sn_params
    params.permit(:facebook, :google).to_h
  end

  def user_params
    params.require(:user).permit(:username, :email, :facebook_id, :password, :password_confirmation)
  end
end
