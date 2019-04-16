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
    user = User.where(email: @data["email"]).first_or_create!(password: SecureRandom.uuid)
    @provider = Provider.where(user_id: user["id"]).first_or_create!(provider: sn_params.keys.join(''), uid: @data["user_id"] || @data["id"])

    if @provider.save
      response.headers["Auth-token"] = user&.generate_token  

      render json: {user: user}
    else
      render  json: { errors: user.errors }, status: 400
    end
  end

  def my_profile
    render json: current_user
  end

  private

  def sn_params
    params.permit(:facebook, :google).to_h
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def provider_params
    params.permit(:provider, :uid)
  end
end
