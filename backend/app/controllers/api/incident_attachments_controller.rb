# frozen_string_literal: true

class Api::IncidentAttachmentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!
  before_action :set_incident
  before_action :authorize_incident_attachment!, only: :create
  before_action :authorize_incident_update!, only: :destroy

  def show
    authorize! :read, @incident
    attachment = @incident.attachments.find(params[:id])
    response.headers['Cache-Control'] = 'private, no-store'
    send_file attachment.file.path, filename: attachment.file.file.original_filename,
              type: 'application/pdf', disposition: 'attachment'
  end

  def create
    attachment = @incident.attachments.build(attachment_params)

    if attachment.save
      render json: { attachment: attachment_json(attachment) }, status: :created
    else
      render json: { errors: attachment.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    attachment = @incident.attachments.find(params[:id])
    attachment.destroy!
    head :no_content
  end

  private

  def set_incident
    @incident = Incident.visible_to(current_user).includes(:attachments).find(params[:incident_id])
  end

  def authorize_incident_attachment!
    return if current_user.admin? || current_user.super_admin?

    authorize! :attach_pdf, @incident
  end

  def authorize_incident_update!
    authorize! :update, @incident
  end

  def attachment_params
    params.require(:attachment).permit(:file)
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
