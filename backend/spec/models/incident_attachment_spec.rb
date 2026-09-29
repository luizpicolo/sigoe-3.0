require 'rails_helper'

RSpec.describe IncidentAttachment, type: :model do
  subject(:attachment) { build(:incident_attachment) }

  it 'is valid with a PDF file' do
    expect(attachment).to be_valid
  end

  it 'rejects files that are not PDFs' do
    attachment.file = Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/files/sample.txt'),
      'text/plain'
    )

    expect(attachment).not_to be_valid
    expect(attachment.errors[:file]).to be_present
  end
end
