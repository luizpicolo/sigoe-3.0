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

  it 'does not expose the removed incident report endpoints' do
    expect do
      Rails.application.routes.recognize_path('/api/report_incidents/data', method: :get)
    end.to raise_error(ActionController::RoutingError)
  end

  it 'uses the API controller stack' do
    expect(ApplicationController.superclass).to eq(ActionController::API)
  end
end
