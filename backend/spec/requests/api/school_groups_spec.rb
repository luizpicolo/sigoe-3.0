require 'rails_helper'

RSpec.describe 'Api::SchoolGroups', type: :request do
  let!(:admin) { create(:user, admin: true) }
  let!(:school_group) { create(:school_group, name: 'Turma Original', identifier: 'T01') }

  describe 'sem autenticação' do
    it 'retorna não autorizado' do
      get '/api/school_groups'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'com autenticação' do
    before { sign_in admin }

    it 'lista turmas' do
      get '/api/school_groups'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('school_groups', 'total')
    end

    it 'consulta turma por id' do
      get "/api/school_groups/#{school_group.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).dig('school_group', 'id')).to eq(school_group.id)
    end

    it 'cria turma' do
      expect do
        post '/api/school_groups', params: { school_group: { name: 'Nova Turma', identifier: 'NT', polo_id: school_group.polo_id } }
      end.to change(SchoolGroup, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'atualiza turma' do
      patch "/api/school_groups/#{school_group.id}", params: { school_group: { name: 'Turma Atualizada' } }
      expect(response).to have_http_status(:ok)
      expect(school_group.reload.name).to eq('Turma Atualizada')
    end

    it 'retorna erro ao criar turma inválida' do
      post '/api/school_groups', params: { school_group: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include('errors')
    end

    it 'remove turma' do
      expect do
        delete "/api/school_groups/#{school_group.id}"
      end.to change(SchoolGroup, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
