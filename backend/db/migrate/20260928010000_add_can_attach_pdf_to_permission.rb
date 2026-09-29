# frozen_string_literal: true

class AddCanAttachPdfToPermission < ActiveRecord::Migration[7.1]
  def change
    add_column :permissions, :can_attach_pdf, :boolean, default: false, null: false
  end
end
