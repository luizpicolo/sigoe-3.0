# frozen_string_literal: true

class Api::DashboardController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!

  def show
    authorize! :read, Incident

    render json: {
      by_years: Incident.by_years(params_return),
      by_courses: Incident.by_courses(params_return),
      by_type_incident: Incident.by_type_incident(params_return),
      by_sanction: Incident.by_sanction(params_return),
      by_is_resolved: Incident.by_is_resolved(params_return)
    }
  end

  private

  def params_return
    return {} if current_user.super_admin?
    return set_polo if set_polo.empty?

    { courses: set_polo }
  end
end
