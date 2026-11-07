# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'luizpicolo@gmail.com'
  layout 'mailer'
end
