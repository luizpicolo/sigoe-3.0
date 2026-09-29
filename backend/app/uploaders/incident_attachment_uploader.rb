# frozen_string_literal: true

class IncidentAttachmentUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.incident_id}"
  end

  def extension_allowlist
    %w[pdf]
  end

  def content_type_allowlist
    %r{\Aapplication/pdf\z}
  end
end
