require 'rails_helper'

RSpec.describe 'Api::Incidents', type: :request do
  let!(:admin) { create(:user, admin: true) }
  let!(:incident) { create(:incident) }

  describe 'sem autenticação' do
    it 'retorna não autorizado' do
      get '/api/incidents'

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'com autenticação' do
    before { sign_in admin }

    it 'lista ocorrências' do
      get '/api/incidents', params: { page: 1, amount: 10 }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to include('incidents', 'total')
      expect(body['incidents'].map { |item| item['id'] }).to include(incident.id)
    end

    it 'filtra ocorrências por busca' do
      get '/api/incidents', params: { search: incident.id.to_s }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['incidents'].map { |item| item['id'] }).to include(incident.id)
    end
  end
end
