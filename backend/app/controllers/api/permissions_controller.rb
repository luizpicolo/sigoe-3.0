# frozen_string_literal: true

class Api::PermissionsController < ApplicationController
  before_action :authenticate_user!

  ENTITIES = {
    'users' => { model: User, name: 'Usuários' },
    'students' => { model: Student, name: 'Estudantes' },
    'courses' => { model: Course, name: 'Cursos' },
    'classes' => { model: SchoolGroup, name: 'Turmas' },
    'occurrences' => { model: Incident, name: 'Ocorrências' }
  }.freeze

  ACTIONS = %w[can_create can_read can_read_restricted can_update can_destroy can_extras can_export_to_academic_system].freeze

  def current
    render json: permission_payload(current_user)
  end

  def show
    authorize_permission_management!
    render json: permission_payload(User.find(params[:user_id]))
  end

  def update
    authorize_permission_management!
    user = User.find(params[:user_id])
    requested_permissions = params.require(:permissions)

    unless requested_permissions.is_a?(Array)
      return render json: { error: 'permissions deve ser um array' }, status: :unprocessable_entity
    end

    normalized = normalize_permissions(requested_permissions)
    return if performed?

    Permission.transaction do
      supported_entities = ENTITIES.values.map { |config| config[:model].name }
      user.permissions.where(entity: supported_entities).delete_all
      normalized.each { |attributes| user.permissions.create!(attributes) }
    end

    render json: permission_payload(user)
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def authorize_permission_management!
    return if current_user.admin?

    render json: { error: 'Apenas administradores podem gerenciar permissões.' }, status: :forbidden
  end

  def permission_payload(user)
    permissions = entity_options.each_with_object({}) do |entity, result|
      permission = user.permissions.find { |item| entity_key(item.entity) == entity[:id] }
      result[entity[:id]] = ACTIONS.index_with do |attribute|
        permission ? permission.public_send("#{attribute}?") : false
      end
    end

    {
      user: user.as_json(only: %i[id name username email admin]),
      admin: user.admin?,
      entities: entity_options,
      permissions: permissions
    }
  end

  def entity_options
    ENTITIES.map do |key, config|
      { id: key, name: config[:name], entity: config[:model].name }
    end
  end

  def normalize_permissions(requested_permissions)
    seen = {}

    requested_permissions.map do |permission|
      attributes = permission.to_h.stringify_keys
      entity_key = attributes['entity'].to_s
      config = ENTITIES[entity_key]

      unless config
        render json: { error: "Entidade inválida: #{entity_key}" }, status: :unprocessable_entity
        return
      end

      if seen[entity_key]
        render json: { error: "Entidade duplicada: #{entity_key}" }, status: :unprocessable_entity
        return
      end

      seen[entity_key] = true
      {
        entity: config[:model].name,
        **ACTIONS.index_with { |attribute| ActiveModel::Type::Boolean.new.cast(attributes[attribute]) }
      }
    end
  end

  def entity_key(entity_name)
    found = ENTITIES.find { |_key, config| config[:model].name == entity_name }
    return found.first if found

    return unless entity_name.present?
    return unless entity_name.safe_constantize&.is_a?(Class)
    return unless entity_name.safe_constantize <= ApplicationRecord

    entity_name.underscore
  end
end
