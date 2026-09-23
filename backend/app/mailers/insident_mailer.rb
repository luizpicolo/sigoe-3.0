# frozen_string_literal: true

class InsidentMailer < ApplicationMailer
  def send_mailer(coordenation)
    @contact = coordenation
    mail(
      to: coordenation,
      from: 'luizpicolo@gmail.com',
      subject: 'Nova ocorrência cadastrada'
    )
  end
end
