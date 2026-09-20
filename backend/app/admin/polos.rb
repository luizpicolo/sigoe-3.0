ActiveAdmin.register Polo do
  menu label: 'Polos'

  permit_params :name, :inicial, :institution_id

  index do
    selectable_column
    id_column
    column :name
    column :inicial
    column :institution
    column :created_at
    actions
  end

  filter :name
  filter :inicial
  filter :institution

  form do |f|
    f.inputs 'Polo' do
      f.input :name
      f.input :inicial
      f.input :institution
    end
    f.actions
  end
end
