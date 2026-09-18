# frozen_string_literal: true

class Api::IncidentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!
  before_action :set_incident, only: :show

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

  def show
    authorize! :read, Incident
    render json: { incident: incident_json(@incident) }
  end

  private

  def set_incident
    @incident = Incident.includes(:student, :course, :type_incident, :user).where(params_return).find(params[:id])
  end

  def params_return
    return '' if current_user.super_admin?
    return set_polo if set_polo.empty?

    params = { courses: set_polo }
    params[:user] = current_user if can?(:read_restricted, Incident) && !current_user.admin? && !current_user.super_admin?
    params
  end

  def incident_json(incident)
    incident.as_json(include: { student: { only: %i[id name] }, course: { only: %i[id name initial polo_id] }, type_incident: { only: %i[id name] }, user: { only: %i[id name] } })
  end
end
