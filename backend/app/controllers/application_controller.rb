# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers

  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.message }, status: :forbidden
  end
end
