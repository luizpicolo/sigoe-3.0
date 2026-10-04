# frozen_string_literal: true

class InsidentMailer < ApplicationMailer
  def send_mailer(coordenation, insident = nil)
    @contact = coordenation
    @insident = insident
    mail(
      to: coordenation,
      from: ENV.fetch('SMTP_FROM', 'sistemas.na@ifms.edu.br'),
      subject: 'Nova ocorrência cadastrada'
    )
  end
end
