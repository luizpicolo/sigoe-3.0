ActiveAdmin.register Course do
  menu label: 'Cursos'

  permit_params :name, :initial, :polo_id

  index do
    selectable_column
    id_column
    column :name
    column :initial
    column :polo
    column :created_at
    actions
  end

  filter :name
  filter :initial
  filter :polo

  form do |f|
    f.inputs 'Curso' do
      f.input :name
      f.input :initial
      f.input :polo
    end
    f.actions
  end
end
