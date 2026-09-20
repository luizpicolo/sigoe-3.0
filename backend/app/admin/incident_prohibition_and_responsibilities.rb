ActiveAdmin.register Incident::ProhibitionAndResponsibility, as: 'Proibição e Responsabilidade' do
  menu label: 'Proibições e responsabilidades'

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
    f.inputs 'Proibição e responsabilidade' do
      f.input :item
      f.input :status
    end
    f.actions
  end
end
