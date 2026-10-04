# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API-only routing', type: :request do
  it 'exposes application routes only below /api' do
    application_paths = Rails.application.routes.routes.filter_map do |route|
      next unless route.defaults[:controller]

      route.path.spec.to_s.delete_suffix('(.:format)')
    end

    expect(application_paths).to all(start_with('/api/'))
  end

  it 'exposes incident report data through the API' do
    route = Rails.application.routes.recognize_path('/api/report_incidents/data', method: :get)

    expect(route[:controller]).to eq('api/report_incidents')
    expect(route[:action]).to eq('data')
  end

  it 'uses the API controller stack' do
    expect(ApplicationController.superclass).to eq(ActionController::API)
  end
end
