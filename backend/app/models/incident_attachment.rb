# frozen_string_literal: true

class IncidentAttachment < ApplicationRecord
  belongs_to :incident

  mount_uploader :file, IncidentAttachmentUploader

  validates :file, presence: true
end
