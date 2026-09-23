# frozen_string_literal: true

class Api::IncidentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!
  before_action :set_incident, only: %i[show update destroy]
  before_action :authorize_private_incident!, only: %i[show update destroy]

  def index
    authorize! :read, Incident
    incidents = Incident.joins(:course).where(params_return).order("#{set_order}": :desc).search(params[:search])
    incidents = incidents.where(user_id: current_user.id) if restricted_read_only?
    incidents = incidents.page(params[:page]).per(set_amount_return)
    render json: { incidents: incidents.map { |incident| incident_json(incident) }, total: incidents.total_count }
  end

  def options
    authorize! :create, Incident
    render json: { assistants: User.where(set_polo).order(:name).as_json(only: %i[id name email]), sectors: Sector.where(set_polo).order(:name).as_json(only: %i[id name email]), type_incidents: Incident::TypeIncident.order(:name).as_json(only: %i[id name]), student_duties: Incident::StudentDuty.where(status: true).order(:id).as_json(only: %i[id item]), prohibition_and_responsibilities: Incident::ProhibitionAndResponsibility.where(status: true).order(:id).as_json(only: %i[id item]), sanctions: can?(:sanction, Incident) ? Incident.sanctions.keys.map { |key| { value: key, label: I18n.t("enums.incident.sanction.#{key}", default: key.humanize) } } : [] }
  end

  def show
    authorize! :read, Incident
    render json: { incident: incident_json(@incident) }
  end

  def create
    authorize! :create, Incident
    student_ids = incident_params[:student_ids]
    attributes = incident_params.except(:student_ids, :student_duty_ids, :prohibition_and_responsibility_ids)
    incidents = Incident.transaction do
      student_ids.map do |student_id|
        student = Student.find(student_id)
        incident = Incident.new(attributes)
        incident.user = current_user
        incident.student = student
        incident.course = student.course
        incident.student_duty_ids = incident_params[:student_duty_ids]
        incident.prohibition_and_responsibility_ids = incident_params[:prohibition_and_responsibility_ids]
        incident.save!
        incident
      end
    end
    render json: { incidents: incidents.map { |incident| incident_json(incident) } }, status: :created
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  def update
    authorize! :update, @incident
    attributes = incident_params.except(:student_ids, :student_duty_ids, :prohibition_and_responsibility_ids)
    @incident.assign_attributes(attributes)
    @incident.student_duty_ids = incident_params[:student_duty_ids] if incident_params.key?(:student_duty_ids)
    @incident.prohibition_and_responsibility_ids = incident_params[:prohibition_and_responsibility_ids] if incident_params.key?(:prohibition_and_responsibility_ids)
    @incident.save!
    render json: { incident: incident_json(@incident) }
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    authorize! :destroy, @incident
    @incident.destroy!
    head :no_content
  end

  private

  def set_incident
    @incident = Incident.includes(:student, :course, :type_incident, :user, :assistant, :student_duties, :prohibition_and_responsibilities).where(params_return).find(params[:id])
  end

  def authorize_private_incident!
    return if @incident.visibility != 'private'
    return if current_user.super_admin? || @incident.user_id == current_user.id

    raise CanCan::AccessDenied
  end

  def restricted_read_only?
    return false if current_user.admin? || current_user.super_admin?

    current_user.permissions.exists?(entity: 'Incident', can_read_restricted: true)
  end

  def params_return
    return '' if current_user.super_admin?
    return set_polo if set_polo.empty?

    { courses: set_polo }
  end

  def incident_params
    permitted = params.require(:incident).permit(:type_incident_id, :student_id, :date_incident, :sector_id, :assistant_id, :time_incident, :institution, :description, :soluction, :is_resolved, :visibility, :type_student, :sanction, student_ids: [], prohibition_and_responsibility_ids: [], student_duty_ids: [])
    return permitted if can?(:sanction, Incident)

    permitted.except(:soluction, :is_resolved, :sanction, :student_duty_ids, :prohibition_and_responsibility_ids)
  end

  def incident_json(incident)
    incident.as_json(include: { student: { only: %i[id name ra photo] }, course: { only: %i[id name initial polo_id], include: { polo: { only: %i[id name] } } }, type_incident: { only: %i[id name] }, sector: { only: %i[id name email] }, user: { only: %i[id name] }, assistant: { only: %i[id name email] }, student_duties: { only: %i[id item] }, prohibition_and_responsibilities: { only: %i[id item] } })
  end
end
