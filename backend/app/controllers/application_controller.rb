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

    @current_user = if token.present?
      payload, = JWT.decode(
        token,
        Rails.application.credentials.jwt_secret_key,
        true,
        { algorithm: 'HS256' }
      )

      User.find_by(id: payload['sub'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end

  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Acesso negado' }, status: :forbidden
  end

  def authenticate_admin!
    redirect_to new_user_session_path unless current_user&.super_admin?
  end
end
