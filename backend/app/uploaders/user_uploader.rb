# frozen_string_literal: true

class UserUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*_args)
    '/default.jpg'
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end
end
