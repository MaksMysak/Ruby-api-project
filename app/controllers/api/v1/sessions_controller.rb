class Api::V1::SessionsController < ApplicationController
  skip_before_action :auth!

  def create
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      response['auth_token'] = @user.generate_token

      render json: { user: @user }
    else
      render json: { errors: @user.errors }, status: 400
    end
  end

  def destroy
    session[:user_id] = nil
    render json: { user: nil }, status: 400
  end
end
