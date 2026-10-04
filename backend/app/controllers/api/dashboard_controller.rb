# frozen_string_literal: true

class Api::DashboardController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!

  def show
    authorize! :read, Incident

    incidents = Incident.visible_to(current_user)

    render json: {
      by_years: incidents.by_years({}),
      by_courses: incidents.by_courses({}),
      by_type_incident: incidents.by_type_incident({}),
      by_sanction: incidents.by_sanction({}),
      by_is_resolved: incidents.by_is_resolved({})
    }
  end

  private

  def params_return
    return {} if current_user.super_admin?
    return set_polo if set_polo.empty?

    { courses: set_polo }
  end
end
