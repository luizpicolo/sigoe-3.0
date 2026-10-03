# frozen_string_literal: true

namespace :attachments do
  desc 'Move existing incident PDFs out of public/ (run with the web server stopped)'
  task privatize: :environment do
    require 'fileutils'
    IncidentAttachment.find_each do |attachment|
      next if attachment.file_identifier.blank?

      source = Rails.root.join('public', attachment.file.store_dir, attachment.file_identifier)
      destination = Pathname.new(attachment.file.path)
      next unless source.file?
      raise "Destination already exists: #{destination}" if destination.exist?

      FileUtils.mkdir_p(destination.dirname)
      FileUtils.mv(source, destination)
    end
  end
end
