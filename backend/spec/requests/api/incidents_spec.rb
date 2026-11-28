require 'rails_helper'

RSpec.describe 'Api::Incidents', type: :request do
  let!(:admin) { create(:user, admin: true) }
  let!(:incident) { create(:incident, course: create(:course, polo: admin.polo)) }

  describe 'sem autenticação' do
    it 'retorna não autorizado' do
      get '/api/incidents'

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'com autenticação' do
    before { sign_in admin, scope: :user }

    it 'lista ocorrências' do
      get '/api/incidents', params: { page: 1, amount: 10 }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to include('incidents', 'total')
      expect(body['incidents'].map { |item| item['id'] }).to include(incident.id)
    end

    it 'retorna os PDFs anexados ao visualizar uma ocorrência' do
      attachment = create(:incident_attachment, incident: incident)

      get "/api/incidents/#{incident.id}"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.dig('incident', 'attachments')).to include(
        hash_including('id' => attachment.id, 'filename' => 'sample.pdf')
      )
    end

    it 'retorna o contato do estudante para habilitar o envio ao responsável' do
      incident.student.update!(contact: '+55 (67) 99999-0000')

      get "/api/incidents/#{incident.id}"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.dig('incident', 'student', 'contact')).to eq('+55 (67) 99999-0000')
    end

    it 'filtra ocorrências por busca' do
      get '/api/incidents', params: { search: incident.id.to_s }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['incidents'].map { |item| item['id'] }).to include(incident.id)
    end

    it 'retorna a hora no formato de relógio local ao visualizar para edição' do
      incident.update!(time_incident: '20:20')

      get "/api/incidents/#{incident.id}"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.dig('incident', 'time_incident')).to eq('20:20')
    end

    it 'retorna a hora no formato local no relatório de ocorrências' do
      incident.update!(time_incident: '20:20', date_incident: Date.current)

      get '/api/report_incidents/data', params: {
        date_start: Date.current.to_s,
        date_final: Date.current.to_s
      }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.first['time_incident']).to eq('20:20')
    end

    it 'não enfileira WhatsApp ao cadastrar ou atualizar ocorrência' do
      student = create(:student, course: create(:course, polo: admin.polo))
      type_incident = create(:type_incident)
      attributes = {
        assistant_id: admin.id,
        student_ids: [student.id],
        type_incident_id: type_incident.id,
        date_incident: Date.current,
        time_incident: '09:15',
        description: 'Teste de não envio automático',
        visibility: 'public'
      }

      expect do
        post '/api/incidents', params: { incident: attributes }
      end.not_to have_enqueued_job(SendIncidentWhatsappJob)
      expect(response).to have_http_status(:created)

      expect do
        put "/api/incidents/#{incident.id}", params: { incident: { description: 'Atualizada' } }
      end.not_to have_enqueued_job(SendIncidentWhatsappJob)
      expect(response).to have_http_status(:ok)
    end

    it 'enfileira o envio manual autorizado se o responsável tem contato' do
      create(:permission, user: admin, entity: 'Incident', can_send_whatsapp: true)
      incident.student.update!(contact: '+55 (67) 99999-0000')

      expect do
        post "/api/incidents/#{incident.id}/send_whatsapp"
      end.to have_enqueued_job(SendIncidentWhatsappJob).with(incident.id)
      expect(response).to have_http_status(:accepted)
    end

    it 'não enfileira envio se o responsável não tem contato' do
      create(:permission, user: admin, entity: 'Incident', can_send_whatsapp: true)
      incident.student.update!(contact: nil)

      expect do
        post "/api/incidents/#{incident.id}/send_whatsapp"
      end.not_to have_enqueued_job(SendIncidentWhatsappJob)
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body['errors'].first).to include('não possui contato')
    end

    it 'recusa o envio manual sem a permissão específica' do
      user = create(:user, admin: false, polo: admin.polo)
      create(:permission, user: user, entity: 'Incident', can_read: true)
      incident.student.update!(contact: '+55 (67) 99999-0000')
      sign_in user, scope: :user

      expect do
        post "/api/incidents/#{incident.id}/send_whatsapp"
      end.not_to have_enqueued_job(SendIncidentWhatsappJob)
      expect(response).to have_http_status(:forbidden)
    end
  end
end
