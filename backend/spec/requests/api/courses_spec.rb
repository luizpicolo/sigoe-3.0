require 'rails_helper'

RSpec.describe 'Api::Courses', type: :request do
  let!(:admin) { create(:user, admin: true) }
  let!(:course) { create(:course, name: 'Curso Original', initial: 'CO') }

  describe 'sem autenticação' do
    it 'retorna não autorizado' do
      get '/api/courses'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'com autenticação' do
    before { sign_in admin }

    it 'lista cursos' do
      get '/api/courses'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('courses', 'total')
    end

    it 'consulta curso por id' do
      get "/api/courses/#{course.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).dig('course', 'id')).to eq(course.id)
    end

    it 'cria curso' do
      expect do
        post '/api/courses', params: { course: { name: 'Novo Curso', initial: 'NC', polo_id: course.polo_id } }
      end.to change(Course, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'atualiza curso' do
      patch "/api/courses/#{course.id}", params: { course: { name: 'Curso Atualizado' } }
      expect(response).to have_http_status(:ok)
      expect(course.reload.name).to eq('Curso Atualizado')
    end

    it 'retorna erro ao criar curso inválido' do
      post '/api/courses', params: { course: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include('errors')
    end

    it 'remove curso' do
      expect do
        delete "/api/courses/#{course.id}"
      end.to change(Course, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
