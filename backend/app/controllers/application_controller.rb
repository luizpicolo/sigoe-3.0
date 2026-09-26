# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  helper_method :current_user

  def authenticate_user!
    return if current_user

    render json: { error: 'Não autorizado' }, status: :unauthorized
  end

  def current_user
    return @current_user if defined?(@current_user)

    token = request.headers['Authorization']&.split(' ')&.last
    return @current_user = nil if token.blank?

    payload, = JWT.decode(
      token,
      Rails.application.credentials.jwt_secret_key,
      true,
      { algorithm: 'HS256' }
    )

    @current_user = User.find_by(id: payload['sub'])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    @current_user = nil
  end

  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Acesso negado' }, status: :forbidden
  end
end
