# frozen_string_literal: true

FactoryBot.define do
  factory :incident_attachment do
    incident
    file do
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec/fixtures/files/sample.pdf'),
        'application/pdf'
      )
    end
  end
end
