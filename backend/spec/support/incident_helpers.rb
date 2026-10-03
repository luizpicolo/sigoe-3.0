# frozen_string_literal: true

module IncidentHelpers
  def params_return(current_user)
    return {} if current_user.super_admin?

    { courses: { polo: current_user.polo_id } }
  end
end
