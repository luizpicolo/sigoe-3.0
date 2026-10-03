# frozen_string_literal: true

# Permite ou restringe acesso a determinadas funcionalidades do sistema
#
# @see https://github.com/ryanb/cancan/wiki/defining-abilities
class Ability
  include CanCan::Ability

  # Método para inicializar as configurações de permissão ou restrição
  def initialize(user)
    user ||= User.new

    can [:manage], :all if user.admin? || user.super_admin?
    user.permissions.each do |permission|
      entity = permission.entity.to_s.safe_constantize
      next unless entity.is_a?(Class) && entity <= ApplicationRecord
      # Permissões extras para ocorrências
      if permission.can_extras?
        can [:sanction], entity if permission.can_extras?
        can [:confirmation], entity if permission.can_extras?
        can [:sign], entity if permission.can_extras?
      end
      can [:attach_pdf], Incident if permission.can_attach_pdf? && permission.entity == 'Incident'
      can [:create], entity if permission.can_create?
      can [:read], entity if permission.can_read_restricted?
      can [:read_restricted], entity if permission.can_read_restricted?
      can [:export_to_academic_system], entity if permission.can_export_to_academic_system?
      can [:read], entity if permission.can_read?
      can [:update], entity if permission.can_update?
      can [:destroy], entity if permission.can_destroy?
    end
  end
end
