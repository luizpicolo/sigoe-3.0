require 'rails_helper'

RSpec.describe 'Api::Users', type: :request do
  let!(:admin) { create(:user, admin: true) }
  let!(:user) { create(:user, name: 'Usuário Original') }

  before { sign_in admin }

  describe 'GET /api/users' do
    it 'lista usuários autenticados' do
      get '/api/users'
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to include('users', 'total')
      expect(body['users'].map { |item| item['id'] }).to include(user.id)
    end
  end

  describe 'GET /api/users/:id' do
    it 'retorna um usuário autenticado' do
      get "/api/users/#{user.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).dig('user', 'id')).to eq(user.id)
    end
  end

  describe 'PUT /api/users/:id' do
    it 'atualiza os dados do usuário sem exigir nova senha' do
      put "/api/users/#{user.id}", params: { user: { name: 'Nome Atualizado', email: user.email } }
      expect(response).to have_http_status(:ok)
      expect(user.reload.name).to eq('Nome Atualizado')
    end

    it 'retorna erros de validação' do
      put "/api/users/#{user.id}", params: { user: { email: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include('errors')
    end
  end

  describe 'DELETE /api/users/:id' do
    it 'remove outro usuário' do
      expect { delete "/api/users/#{user.id}" }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'impede que o usuário autenticado seja excluído' do
      delete "/api/users/#{admin.id}"
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Não é possível excluir o próprio usuário')
    end
  end
end
