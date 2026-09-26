# frozen_string_literal: true

class Api::ReportIncidentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!

  def options
  authorize! :read, Incident

  render json: {
      students: Student
        .joins(:course)
        .where(params_return)
        .where(course_situation: 5)
        .order(:name)
        .as_json(only: %i[id name]),

      courses: Course
        .where(params_return)
        .order(:name)
        .as_json(only: %i[id name]),

      school_groups: school_groups,

      type_incidents: Incident::TypeIncident
        .order(:name)
        .as_json(only: %i[id name])
    }
  end

  def data
    authorize! :read, Incident

    incidents = filtered_incidents
    if incidents.blank?
      render json: { error: 'Não foi encontrada ocorrência para estes parâmetros' }, status: :not_found
      return
    end

    render json: incidents.map { |incident|
      {
        student: incident.student_name,
        course: incident.course_name,
        date_incident: incident.date_incident,
        time_incident: incident.time_incident,
        type_incident: incident.type_incident.name,
        description: incident.description
      }
    }
  end

  def create
    authorize! :read, Incident
    incidents = filtered_incidents

    if incidents.blank?
      render json: { error: 'Não foi encontrada ocorrência para estes parâmetros' }, status: :not_found
      return
    end

    @incidents = incidents
    render pdf: 'relatorio-ocorrencias', template: 'report_incidents/create', layout: false
  end

  private

  def school_groups
    scope = SchoolGroup.joins(:polo)

    unless current_user.super_admin?
      scope = scope.where(polo: params_return[:courses][:polo])
    end

    scope.order(:name).as_json(only: %i[id name])
  end

  def filtered_incidents
    can_read_restricted = current_user.permissions.exists?(
      entity: 'Incident',
      can_read_restricted: true
    )

    scope = Incident.joins(:student, :course)

    if can_read_restricted
      # Pode visualizar somente as ocorrências que ele criou
      scope = scope.where(user_id: current_user.id)
    else
      # Pode visualizar todas as públicas
      # + privadas criadas por ele
      scope = scope.where(
        "incidents.visibility = :public OR
        (incidents.visibility = :private AND incidents.user_id = :user_id)",
        public: 'public',
        private: 'private',
        user_id: current_user.id
      )
    end

    scope
      .where(params_return)
      .search(search_params)
      .where(date_incident: date_start..date_final)
      .order(date_incident: :desc)
  end

  def date_start
    Date.parse(params.require(:date_start))
  end

  def date_final
    Date.parse(params.require(:date_final))
  end

  def search_params
    conditionals = {}
    conditionals[:student] = params[:student] if params[:student].present?
    conditionals[:course] = params[:course] if params[:course].present?
    conditionals[:school_group] = params[:school_group] if params[:school_group].present?
    conditionals[:type_incident_id] = params[:type_incident_id] if params[:type_incident_id].present?
    conditionals[:type_student] = params[:type_student] if params[:type_student].present?
    conditionals[:is_resolved] = params[:is_resolved] if params[:is_resolved].present?
    conditionals
  end

  def params_return
    return {} if current_user.super_admin?
    return set_polo if set_polo.empty?
    
    { courses: set_polo }
  end
end
