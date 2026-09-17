# frozen_string_literal: true

# == Schema Information
#
# Table name: permissions
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  entity      :string
#  can_create  :boolean          default("false")
#  can_read    :boolean          default("false")
#  can_update  :boolean          default("false")
#  can_destroy :boolean          default("false")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  can_manage  :boolean          default("false")
#  can_extras  :boolean          default("false")
#

class Permission < ApplicationRecord
  include SearchCop

  validates :user, presence: true
  validate :entity_must_be_an_application_record

  belongs_to :user

  search_scope :search do
    attributes user: 'user.name'
  end

  def self.ordenation_attributes
    [%w[ID id], %w[User user]]
  end

  private

  def entity_must_be_an_application_record
    model = entity.to_s.safe_constantize
    return if model.is_a?(Class) && model <= ApplicationRecord

    errors.add(:entity, 'deve ser uma entidade válida do sistema')
  end
end
