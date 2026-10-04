# frozen_string_literal: true

Rails.application.configure do
  config.action_mailer.default_url_options = { host: ENV['SMTP_DOMAIN'] }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = Rails.env.test? ? :test : :smtp
  config.action_mailer.smtp_settings = {
      address: ENV['SMTP_ADDRESS'],
      port: ENV['SMTP_PORT'],
      domain: ENV['SMTP_DOMAIN'],
      user_name: ENV['SMTP_USER_NAME'],
      password: ENV['SMTP_PASSWORD'],
      authentication: 'plain',
      enable_starttls_auto: true
  }
end
