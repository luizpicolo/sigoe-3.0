# frozen_string_literal: true

class Api::ReportIncidentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!

  def options
    authorize! :read, Incident

    render json: {
      students: Student.where(params_return).where(course_situation: 5).order(:name).as_json(only: %i[id name]),
      courses: Course.where(params_return).order(:name).as_json(only: %i[id name]),
      school_groups: SchoolGroup.where(params_return).order(:name).as_json(only: %i[id name]),
      type_incidents: Incident::TypeIncident.order(:name).as_json(only: %i[id name])
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

  def filtered_incidents
    Incident.joins(:student, :course)
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
