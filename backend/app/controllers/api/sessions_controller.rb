# frozen_string_literal: true

class Api::SessionsController < Devise::SessionsController
  layout false
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  respond_to :json

  def create
    credentials = params.require(:user).permit(:username, :password)
    user = User.find_for_database_authentication(username: credentials[:username])

    unless user&.valid_password?(credentials[:password])
      render json: { error: 'Usuário ou senha inválidos' }, status: :unauthorized
      return
    end

    sign_in(:user, user)
    token = JWT.encode(
      {
        sub: user.id,
        exp: 30.minutes.from_now.to_i
      },
      Rails.application.credentials.jwt_secret_key,
      'HS256'
    )

    response.set_header('Authorization', "Bearer #{token}")
    render json: { user: user, message: 'Login realizado com sucesso' }, status: :ok
  rescue ActionController::ParameterMissing
    render json: { error: 'Usuário e senha são obrigatórios' }, status: :bad_request
  rescue ActionDispatch::Http::Parameters::ParseError
    render json: { error: 'Corpo da requisição JSON inválido' }, status: :bad_request
  end
end
