# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'sigeo@ifms.edu.br'
  layout 'mailer'
end
