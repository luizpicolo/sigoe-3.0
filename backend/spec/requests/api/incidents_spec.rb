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
  end
end
