require 'rails_helper'

RSpec.describe 'API token authentication', type: :request do
  it 'uses the login bearer token on a separate client without session cookies' do
    user = create(:user, password: 'test-password', password_confirmation: 'test-password')
    post '/api/auth/login', params: { user: { username: user.username, password: 'test-password' } }, as: :json
    expect(response).to have_http_status(:ok)
    token = response.headers.fetch('Authorization')
    client = ActionDispatch::Integration::Session.new(Rails.application)
    client.get '/api/permissions/current', headers: { 'Authorization' => token }
    expect(client.response).to have_http_status(:ok)
    expect(client.response.parsed_body.dig('user', 'id')).to eq(user.id)
    client.delete '/api/auth/logout', headers: { 'Authorization' => token }
    expect(client.response).to have_http_status(:no_content)
    client.get '/api/permissions/current', headers: { 'Authorization' => token }
    expect(client.response).to have_http_status(:unauthorized)
  end

  it 'rejects disabled accounts at login' do
    user = create(:user, status: false, password: 'test-password', password_confirmation: 'test-password')
    post '/api/auth/login', params: { user: { username: user.username, password: 'test-password' } }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
