# frozen_string_literal: true

class Api::IncidentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!
  before_action :set_incident, only: %i[show update destroy]

  def index
    authorize! :read, Incident

    incidents = Incident.visible_to(current_user)
                        .preload(:student, :type_incident, :sector, :user, :assistant,
                                 :student_duties, :prohibition_and_responsibilities, :attachments, course: :polo)
                        .order("#{set_order}": :desc).search(params[:search])
    incidents = incidents.page(params[:page]).per(set_amount_return)

    render json: { incidents: incidents.map { |incident| incident_json(incident) }, total: incidents.total_count }
  end

  def options
    authorize! :create, Incident

    render json: { assistants: campus_scope(User).order(:name).as_json(only: %i[id name email]), sectors: campus_scope(Sector).order(:name).as_json(only: %i[id name email]), type_incidents: Incident::TypeIncident.order(:name).as_json(only: %i[id name]), student_duties: Incident::StudentDuty.where(status: true).order(:id).as_json(only: %i[id item]), prohibition_and_responsibilities: Incident::ProhibitionAndResponsibility.where(status: true).order(:id).as_json(only: %i[id item]), sanctions: can?(:sanction, Incident) ? Incident.sanctions.keys.map { |key| { value: key, label: I18n.t("enums.incident.sanction.#{key}", default: key.humanize) } } : [] }
  end

  def show
    authorize! :read, Incident
    render json: { incident: incident_json(@incident) }
  end

  def create
    authorize! :create, Incident

    student_ids = incident_params[:student_ids]
    if student_ids.blank?
      return render json: { errors: ['Selecione pelo menos um estudante.'] }, status: :unprocessable_content
    end
    attributes = incident_params.except(:student_ids, :student_duty_ids, :prohibition_and_responsibility_ids)

    incidents = Incident.transaction do
      student_ids.map do |student_id|
        student = campus_scope(Student).find(student_id)
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

    if incident_params[:sector_id].present?
      sector = Sector.find(incident_params[:sector_id])
      incidents.each { 
        |incident| send_email_to(sector.email, incident) 
      }
    end

    render json: { incidents: incidents.map { |incident| incident_json(incident) } }, status: :created
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :unprocessable_content
  end

  def update
    authorize! :update, @incident

    attributes = incident_params.except(:student_ids, :student_duty_ids, :prohibition_and_responsibility_ids)
    @incident.assign_attributes(attributes)
    @incident.student_duty_ids = incident_params[:student_duty_ids] if incident_params.key?(:student_duty_ids)
    @incident.prohibition_and_responsibility_ids = incident_params[:prohibition_and_responsibility_ids] if incident_params.key?(:prohibition_and_responsibility_ids)
    @incident.save!

    if incident_params[:sector_id].present?
      sector = Sector.find(incident_params[:sector_id])
      send_email_to(sector.email, @incident)
    end

    render json: { incident: incident_json(@incident) }
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_content
  end

  def destroy
    authorize! :destroy, @incident
    @incident.destroy!
    head :no_content
  end

  private

  def send_email_to(sector, incident = nil)
    return if Rails.env.test?
    InsidentMailer.send_mailer(sector, incident).deliver_later if sector.present?
  rescue StandardError => e
    Rails.logger.error("Erro ao enviar e-mail da ocorrência: #{e.message}")
  end

  def set_incident
    @incident = Incident.visible_to(current_user).includes(:student, :course, :type_incident, :user, :assistant, :student_duties, :prohibition_and_responsibilities, :attachments).find(params[:id])
  end

  def params_return
    return '' if current_user.super_admin?
    return set_polo if set_polo.empty?

    { courses: set_polo }
  end

  def incident_params
    permitted = params.require(:incident).permit(:type_incident_id, :date_incident, :sector_id, :assistant_id, :time_incident, :institution, :description, :soluction, :is_resolved, :visibility, :type_student, :sanction, student_ids: [], prohibition_and_responsibility_ids: [], student_duty_ids: [])
    validate_campus_links!(permitted, assistant_id: User, sector_id: Sector)
    return permitted if can?(:sanction, Incident)

    permitted.except(:soluction, :is_resolved, :sanction, :student_duty_ids, :prohibition_and_responsibility_ids)
  end

  def incident_json(incident)
    incident.as_json(include: { student: { only: %i[id name ra photo] }, course: { only: %i[id name initial polo_id], include: { polo: { only: %i[id name] } } }, type_incident: { only: %i[id name] }, sector: { only: %i[id name email] }, user: { only: %i[id name] }, assistant: { only: %i[id name email] }, student_duties: { only: %i[id item] }, prohibition_and_responsibilities: { only: %i[id item] } }).merge('attachments' => incident.attachments.map { |attachment| attachment_json(attachment) })
  end

  def attachment_json(attachment)
    {
      id: attachment.id,
      filename: attachment.file.file.original_filename,
      url: api_incident_attachment_path(attachment.incident_id, attachment.id),
      created_at: attachment.created_at
    }
  end
end