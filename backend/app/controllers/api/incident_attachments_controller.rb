# frozen_string_literal: true

class Api::IncidentAttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_incident
  before_action :authorize_private_incident!
  before_action :authorize_incident_attachment!, only: :create
  before_action :authorize_incident_update!, only: :destroy

  def create
    attachment = @incident.attachments.build(attachment_params)

    if attachment.save
      render json: { attachment: attachment_json(attachment) }, status: :created
    else
      render json: { errors: attachment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    attachment = @incident.attachments.find(params[:id])
    attachment.destroy!
    head :no_content
  end

  private

  def set_incident
    @incident = Incident.includes(:attachments).where(params_return).find(params[:incident_id])
  end

  def authorize_incident_attachment!
    return if current_user.admin? || current_user.super_admin?

    authorize! :attach_pdf, @incident
  end

  def authorize_incident_update!
    authorize! :update, @incident
  end

  def authorize_private_incident!
    return if @incident.visibility != 'private'
    return if current_user.super_admin? || @incident.user_id == current_user.id

    raise CanCan::AccessDenied
  end

  def params_return
    return '' if current_user.super_admin?
    return set_polo if set_polo.empty?

    { courses: set_polo }
  end

  def attachment_params
    params.require(:attachment).permit(:file)
  end

  def attachment_json(attachment)
    {
      id: attachment.id,
      filename: attachment.file.file.original_filename,
      url: attachment.file.url,
      created_at: attachment.created_at
    }
  end
end
