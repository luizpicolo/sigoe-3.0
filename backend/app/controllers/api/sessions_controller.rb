class Api::SessionsController < Devise::SessionsController
  layout false
  skip_before_action :verify_authenticity_token
  respond_to :json
  skip_before_action :verify_signed_out_user, only: :destroy
  before_action :authenticate_user!, only: :destroy

  def create
    credentials = params.require(:user).permit(:username, :password)
    user = User.find_for_database_authentication(username: credentials[:username])

    unless user&.valid_password?(credentials[:password]) && user.active_for_authentication?
      render json: { error: 'Usuário ou senha inválidos' }, status: :unauthorized
      return
    end

    sign_in(:user, user)
    token, = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)

    response.set_header('Authorization', "Bearer #{token}")
    render json: { user: user, message: 'Login realizado com sucesso' }, status: :ok
  rescue ActionController::ParameterMissing
    render json: { error: 'Usuário e senha são obrigatórios' }, status: :bad_request
  rescue ActionDispatch::Http::Parameters::ParseError
    render json: { error: 'Corpo da requisição JSON inválido' }, status: :bad_request
  end

  def destroy
    token = request.headers['Authorization']&.split(' ')&.last
    if token.present?
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      raise JWT::DecodeError unless payload['sub'].to_s == current_user.id.to_s

      JwtDenylist.revoke_jwt(payload, current_user) unless JwtDenylist.jwt_revoked?(payload, current_user)
    end
    sign_out(:user)
    head :no_content
  rescue JWT::DecodeError
    render json: { error: 'Token inválido.' }, status: :unauthorized
  end
end
