# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include CampusAccess

  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.json { render json: { error: 'Acesso não autorizado.' }, status: :forbidden }
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.json { render json: { error: 'Registro não encontrado.' }, status: :not_found }
      format.html { head :not_found }
    end
  end

  def authenticate_admin!
    redirect_to new_user_session_path unless current_user&.super_admin?
  end
end
