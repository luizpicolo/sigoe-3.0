ActiveAdmin.register Incident::StudentDuty, as: 'StudentDuty' do
  menu label: 'Atividades do aluno'

  permit_params :item, :status

  index do
    selectable_column
    id_column
    column :item
    column :status
    column :created_at
    actions
  end

  filter :item
  filter :status

  form do |f|
    f.inputs 'Atividade do aluno' do
      f.input :item
      f.input :status
    end
    f.actions
  end
end
