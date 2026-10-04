require 'rails_helper'

RSpec.describe 'Api::IncidentAttachments', type: :request do
  let!(:admin) { create(:user, admin: true) }
  let!(:incident) { create(:incident, course: create(:course, polo: admin.polo)) }

  before { sign_in admin, scope: :user }

  describe 'POST /api/incidents/:incident_id/attachments' do
    it 'envia um PDF para a ocorrência' do
      expect do
        post "/api/incidents/#{incident.id}/attachments",
             params: {
               attachment: {
                 file: Rack::Test::UploadedFile.new(
                   Rails.root.join('spec/fixtures/files/sample.pdf'),
                   'application/pdf'
                 )
               }
             }
      end.to change(IncidentAttachment, :count).by(1)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body.dig('attachment', 'filename')).to eq('sample.pdf')
      expect(body.dig('attachment', 'url')).to be_present
    end


    it 'exige a permissão de envio de PDF para usuários não administradores' do
      user = create(:user, polo: admin.polo)
      sign_in user, scope: :user

      post "/api/incidents/#{incident.id}/attachments",
           params: {
             attachment: {
               file: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec/fixtures/files/sample.pdf'),
                 'application/pdf'
               )
             }
           }

      expect(response).to have_http_status(:forbidden)
    end

    it 'permite o envio quando o usuário possui a permissão de PDF em ocorrências' do
      user = create(:user, polo: admin.polo)
      create(:permission, user: user, entity: 'Incident', can_attach_pdf: true)
      sign_in user, scope: :user

      post "/api/incidents/#{incident.id}/attachments",
           params: {
             attachment: {
               file: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec/fixtures/files/sample.pdf'),
                 'application/pdf'
               )
             }
           }

      expect(response).to have_http_status(:created)
    end

    it 'rejeita arquivo que não é PDF' do
      post "/api/incidents/#{incident.id}/attachments",
           params: {
             attachment: {
               file: Rack::Test::UploadedFile.new(
                 Rails.root.join('spec/fixtures/files/sample.txt'),
                 'text/plain'
               )
             }
           }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end

  describe 'DELETE /api/incidents/:incident_id/attachments/:id' do
    it 'remove o PDF da ocorrência' do
      attachment = create(:incident_attachment, incident: incident)

      expect do
        delete "/api/incidents/#{incident.id}/attachments/#{attachment.id}"
      end.to change(IncidentAttachment, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
