# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class SendIncidentWhatsappJob < ApplicationJob
  queue_as :default

  retry_on Net::OpenTimeout, Net::ReadTimeout, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError,
           wait: :polynomially_longer, attempts: 5

  def perform(incident_id)
    incident = Incident.includes(:student).find_by(id: incident_id)
    return unless incident

    student = incident.student
    phone = student&.contact.to_s.gsub(/\D/, '')
    return if phone.blank?

    phone = "55#{phone}" unless phone.start_with?('55')
    payload = {
      to: phone,
      nome: student&.responsible,
      data: incident.date_incident&.strftime('%d/%m/%Y'),
      filho: student&.name,
      descricao: incident.description,
      link: "https://sigoe.na.ifms.edu.br/ocorrencias/ocorrencias/visualizar/#{incident.id}"
    }

    missing_fields = payload.select { |_field, value| value.blank? }.keys
    if missing_fields.any?
      Rails.logger.warn("WhatsApp não enviado para ocorrência #{incident.id}: campos vazios #{missing_fields.join(', ')}")
      return
    end

    uri = URI.join("#{ENV.fetch('BAILEYS_URL').chomp('/')}/", 'messages')
    request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
    request.body = JSON.generate(payload)

    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 5
    http.read_timeout = 10
    response = http.request(request)
    return if response.is_a?(Net::HTTPSuccess)

    raise "Baileys respondeu HTTP #{response.code}: #{response.body}"
  end
end
