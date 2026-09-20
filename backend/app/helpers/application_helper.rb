# frozen_string_literal: true

# Módulo para funções diversas, sem associação com uma entidade em específico
#
module ApplicationHelper
  # Mostra mensagem flash de erro caso a entidade não seja criada
  #
  # @param entity [Object] entidade
  # @param params [Array<String>] contendo os parâmetros carregados via Get
  # @return mensagem flash de erro
  def show_search_error_message(entity, params)
    return if entity.present?

    flash.now[:error] = "Sua busca por <b>#{params[:search]}</b> não obteve resutados"
  end

  def attr_order(relation)
    entity = convert_to_entity(relation)
    entity.ordenation_attributes
  end

  def convert_to_entity(relation)
    entity = relation.class.to_s
    entity.slice!('::ActiveRecord_Relation')
    eval(entity)
  end

  def options_for_search(params)
    options_for_select(%w[15 30 45 50 75 100], params[:return])
  end

  def extract_and_format_date(date = nil)
    d = date.presence || Time.current
    d.strftime('%d/%m/%Y')
  end

  def extract_and_format_time(time = nil)
    t = time.presence || Time.current
    t.strftime('%H:%M')
  end

  def status?(val)
    if [1, true, 'public'].include?(val)
      '<i title="Ativo" class="fa fa-check"></i>'
    else
      '<i title="Inativo" class="fa fa-times"></i>'
    end
  end

  # Converte e traduz um conjunto de atributos em um hash
  #
  # @example human_enum_name('incident.type_student', array_attrs) #=> {'Não residente' => 'non_resident'}
  #
  # @param model [String]
  # @param attrs [Array<String>]
  # @return [Hash]
  def human_enum_name(model, attrs)
    hash = {}
    attrs.each do |attr|
      key = I18n.t("enums.#{model}.#{attr}", default: attr.humanize)
      hash[key] = attr
    end
    hash
  end

  def models
    ApplicationRecord.descendants.map(&:name)
  end
end
