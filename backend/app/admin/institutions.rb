ActiveAdmin.register Institution do
  menu label: 'Instituições'

  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs 'Instituição' do
      f.input :name
    end
    f.actions
  end
end
