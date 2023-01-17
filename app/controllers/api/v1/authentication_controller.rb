class Api::V1::AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      require('json_web_token')
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { user: @user, token:, exp: time.strftime('%m-%d-%Y %H:%M') }, except: [:password_digest],
             status: :ok
    else
      render json: { errors: ['Wrong credentials'] }, status: :unauthorized
    end
  end

  def get_me
    render json: @current_user, except: [:password_digest], status: :ok
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
