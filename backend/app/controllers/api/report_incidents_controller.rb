# frozen_string_literal: true

class Api::ReportIncidentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!

  def create
    authorize! :read, Incident

    incidents = Incident.joins(:student, :course)
                        .where(params_return)
                        .search(search_params)
                        .where(date_incident: date_start..date_final)
                        .order(date_incident: :desc)

    if incidents.blank?
      render json: { error: 'Não foi encontrada ocorrência para estes parâmetros' }, status: :not_found
      return
    end

    @incidents = incidents
    render pdf: 'relatorio-ocorrencias', template: 'report_incidents/create', layout: false
  end

  private

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
