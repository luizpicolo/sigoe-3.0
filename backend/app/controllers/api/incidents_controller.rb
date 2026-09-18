# frozen_string_literal: true

class Api::IncidentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!

  def index
    authorize! :read, Incident
    incidents = Incident.joins(:course)
                        .where(params_return)
                        .order("#{set_order}": :desc)
                        .search(params[:search])
                        .page(params[:page])
                        .per(set_amount_return)

    render json: { incidents: incidents.map { |incident| incident_json(incident) }, total: incidents.total_count }
  end

  private

  def params_return
    return '' if current_user.super_admin?
    return set_polo if set_polo.empty?

    params = { courses: set_polo }
    params[:user] = current_user if can?(:read_restricted, Incident) && !current_user.admin? && !current_user.super_admin?
    params
  end

  def incident_json(incident)
    incident.as_json(only: %i[id date_incident time_incident visibility is_resolved signed_in student_id course_id type_incident_id user_id], include: { student: { only: %i[id name] }, course: { only: %i[id name initial] }, type_incident: { only: %i[id name] }, user: { only: %i[id name] } })
  end
end
