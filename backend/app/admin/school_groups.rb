ActiveAdmin.register SchoolGroup do
  menu label: 'Turmas'

  permit_params :name, :identifier, :polo_id

  index do
    selectable_column
    id_column
    column :name
    column :identifier
    column :polo
    column :created_at
    actions
  end

  filter :name
  filter :identifier
  filter :polo

  form do |f|
    f.inputs 'Turma' do
      f.input :name
      f.input :identifier
      f.input :polo
    end
    f.actions
  end
end
