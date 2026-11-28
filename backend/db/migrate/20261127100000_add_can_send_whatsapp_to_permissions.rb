# frozen_string_literal: true

class AddCanSendWhatsappToPermissions < ActiveRecord::Migration[8.1]
  def change
    add_column :permissions, :can_send_whatsapp, :boolean, default: false, null: false
  end
end
