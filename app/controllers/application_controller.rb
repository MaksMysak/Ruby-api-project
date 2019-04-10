class ApplicationController < ActionController::API
  before_action :auth!

  def auth!
    if current_user.blank?
      render json: {error: "Auth error"}, status: 401
      return
    end
  end

  def current_user
    @current_user ||= User.where('? = ANY (tokens)', request.headers['Auth-token']).first
  end
end
