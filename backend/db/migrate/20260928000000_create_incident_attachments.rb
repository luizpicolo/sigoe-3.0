class CreateIncidentAttachments < ActiveRecord::Migration[7.1]
  def change
    create_table :incident_attachments do |t|
      t.references :incident, null: false, foreign_key: true
      t.string :file

      t.timestamps
    end
  end
end
