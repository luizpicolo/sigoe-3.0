require 'rails_helper'

RSpec.describe 'Api::Students', type: :request do
  let!(:admin) { create(:user, admin: true) }
  let!(:student) { create(:student, name: 'Estudante Original') }

  describe 'sem autenticação' do
    it 'retorna não autorizado' do
      get '/api/students'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'com autenticação' do
    before { sign_in admin }

    it 'lista estudantes' do
      get '/api/students'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('students', 'total')
    end

    it 'consulta estudante por id' do
      get "/api/students/#{student.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).dig('student', 'id')).to eq(student.id)
    end

    it 'cria estudante' do
      expect do
        post '/api/students', params: { student: { name: 'Novo Estudante', ra: '87654321', course_id: student.course_id, school_group_id: student.school_group_id, password: 'password', password_confirmation: 'password' } }
      end.to change(Student, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'atualiza estudante' do
      patch "/api/students/#{student.id}", params: { student: { name: 'Estudante Atualizado' } }
      expect(response).to have_http_status(:ok)
      expect(student.reload.name).to eq('Estudante Atualizado')
    end

    it 'retorna erro ao criar estudante inválido' do
      post '/api/students', params: { student: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include('errors')
    end

    it 'remove estudante' do
      expect do
        delete "/api/students/#{student.id}"
      end.to change(Student, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
