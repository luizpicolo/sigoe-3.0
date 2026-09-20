ActiveAdmin.register Incident::TypeIncident, as: 'TypeIncident' do
  menu label: 'Tipos de ocorrência'

  permit_params :name, :old_id

  index do
    selectable_column
    id_column
    column :name
    column :old_id
    column :created_at
    actions
  end

  filter :name
  filter :old_id

  form do |f|
    f.inputs 'Tipo de ocorrência' do
      f.input :name
      f.input :old_id
    end
    f.actions
  end
end
