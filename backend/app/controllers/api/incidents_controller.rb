# frozen_string_literal: true

class Api::IncidentsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :read, Incident
    incidents = Incident.includes(:student, :course, :type_incident, :user).order(date_incident: :desc, id: :desc)
    incidents = incidents.where('incidents.id::text ILIKE :search OR students.name ILIKE :search OR courses.name ILIKE :search', search: "%#{params[:search]}%").joins('LEFT JOIN students ON students.id = incidents.student_id').joins('LEFT JOIN courses ON courses.id = incidents.course_id') if params[:search].present?
    total = incidents.count
    amount = params[:amount].to_i.clamp(1, 100)
    page = [params[:page].to_i, 1].max
    incidents = incidents.offset((page - 1) * amount).limit(amount)
    render json: { incidents: incidents.map { |incident| incident_json(incident) }, total: total }
  end

  private

  def incident_json(incident)
    incident.as_json(only: %i[id date_incident time_incident visibility is_resolved signed_in student_id course_id type_incident_id user_id], include: { student: { only: %i[id name] }, course: { only: %i[id name initial] }, type_incident: { only: %i[id name] }, user: { only: %i[id name] } })
  end
end
