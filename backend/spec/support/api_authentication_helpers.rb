# frozen_string_literal: true

module ApiAuthenticationHelpers
  REQUEST_METHODS = %i[get post put patch delete].freeze

  def sign_in(resource, scope: nil)
    @api_authenticated_resource = resource
  end

  def sign_out(scope = nil)
    @api_authenticated_resource = nil
  end

  REQUEST_METHODS.each do |request_method|
    define_method(request_method) do |path, **options|
      headers = options.delete(:headers) || {}
      if @api_authenticated_resource
        token, = Warden::JWTAuth::UserEncoder.new.call(@api_authenticated_resource, :user, nil)
        headers = headers.merge('Authorization' => "Bearer #{token}")
      end
      super(path, headers: headers, **options)
    end
  end
end
