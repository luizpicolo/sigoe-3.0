# frozen_string_literal: true

# Shared by the JSON API and the legacy HTML controllers.
module CampusAccess
  extend ActiveSupport::Concern

  private

  def campus_scope(model)
    return model.all if current_user.super_admin?
    return model.none if current_user.polo_id.nil?

    if [Student, Incident].include?(model)
      model.joins(:course).where(courses: { polo_id: current_user.polo_id })
    else
      model.where(polo_id: current_user.polo_id)
    end
  end

  def scoped_user(id, write: false)
    user = campus_scope(User).find(id)
    if write && !current_user.super_admin? &&
       (user.super_admin? || (user.admin? && !current_user.admin?))
      raise CanCan::AccessDenied
    end
    user
  end

  def campus_attributes(attributes)
    return attributes if current_user.super_admin?
    raise CanCan::AccessDenied if current_user.polo_id.nil?
    if attributes[:polo_id].present? && attributes[:polo_id].to_s != current_user.polo_id.to_s
      raise CanCan::AccessDenied
    end
    attributes.merge(polo_id: current_user.polo_id)
  end

  def validate_campus_links!(attributes, links)
    links.each do |key, model|
      campus_scope(model).find(attributes[key]) if attributes[key].present?
    end
    attributes
  end

  def permitted_user_attributes
    attributes = params.require(:user).permit(
      :name, :siape, :username, :email, :password, :password_confirmation,
      :status, :avatar, :course_id, :admin, :polo_id
    )
    if attributes.key?(:admin) && !(current_user.admin? || current_user.super_admin?)
      raise CanCan::AccessDenied if ActiveModel::Type::Boolean.new.cast(attributes[:admin])
      attributes.delete(:admin)
    end
    validate_campus_links!(attributes, course_id: Course)
    campus_attributes(attributes)
  end
end
