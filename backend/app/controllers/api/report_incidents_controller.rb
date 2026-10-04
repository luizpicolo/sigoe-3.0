# frozen_string_literal: true

class Api::ReportIncidentsController < ApplicationController
  include ParamsSearch

  def options
    authorize! :read, Incident

    render json: {
      students: Student.joins(:course).where(params_return).where(course_situation: 5)
        .order(:name).as_json(only: %i[id name]),
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

  private

  def filtered_incidents
    scope = Incident.joins(:student, :course)
    scope = scope.where(user_id: current_user.id) if current_user.permissions.exists?(entity: 'Incident', can_read_restricted: true)
    scope = scope.where("incidents.visibility = :public OR (incidents.visibility = :private AND incidents.user_id = :user_id)", public: 'public', private: 'private', user_id: current_user.id)
    scope.where(params_return).search(search_params).where(date_incident: date_start..date_final).order(date_incident: :desc)
  end

  def date_start
    Date.parse(params.require(:date_start))
  end

  def date_final
    Date.parse(params.require(:date_final))
  end

  def search_params
    %i[student course school_group type_incident_id type_student is_resolved].each_with_object({}) do |key, values|
      values[key] = params[key] if params[key].present?
    end
  end
end
