# frozen_string_literal: true

module ParamsSearch
  extend ActiveSupport::Concern

  def set_order
    params[:order].presence || 'id'
  end

  def set_polo
    current_user.super_admin? ? '' : { polo: current_user.polo_id }
  end

  def set_amount_return
    amount = (params[:amount].presence || params[:return].presence || 15).to_i
    amount.positive? ? [amount, 100].min : 15
  end
end