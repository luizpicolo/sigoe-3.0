# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
  include CampusAccess

  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Acesso não autorizado.' }, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Registro não encontrado.' }, status: :not_found
  end
end
