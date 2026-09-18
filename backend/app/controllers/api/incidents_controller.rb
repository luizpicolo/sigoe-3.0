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

  def create
    authorize! :create, Incident
    student_ids = incident_params[:student_ids]
    attributes = incident_params.except(:student_ids)

    incidents = Incident.transaction do
      student_ids.map do |student_id|
        student = Student.find(student_id)
        incident = Incident.new(attributes)
        incident.user = current_user
        incident.student = student
        incident.course = student.course
        incident.save!
        incident
      end
    end

    render json: { incidents: incidents.map { |incident| incident_json(incident) } }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
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

  def incident_params
    params.require(:incident).permit(
      :type_incident_id, :date_incident, :sector_id, :assistant_id, :time_incident, :institution, :description, :soluction, :is_resolved, :visibility, :type_student, :sanction, student_ids: [], prohibition_and_responsibility_ids: [], student_duty_ids: []
    )
  end

  def incident_json(incident)
    incident.as_json(include: { student: { only: %i[id name] }, course: { only: %i[id name initial polo_id] }, type_incident: { only: %i[id name] }, user: { only: %i[id name] } })
  end
end
