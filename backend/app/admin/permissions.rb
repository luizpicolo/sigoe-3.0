ActiveAdmin.register Permission do
  menu label: 'Permissões'

  permit_params :user_id, :entity, :can_create, :can_read, :can_update, :can_destroy,
                :can_manage, :can_extras, :can_read_restricted, :can_export_to_academic_system

  index do
    selectable_column
    id_column
    column :user
    column :entity
    column :can_create
    column :can_read
    column :can_update
    column :can_destroy
    column :can_manage
    column :can_extras
    column :can_read_restricted
    column :can_export_to_academic_system
    actions
  end

  filter :user
  filter :entity

  form do |f|
    f.inputs 'Permissão' do
      f.input :user
      f.input :entity
      f.input :can_create
      f.input :can_read
      f.input :can_update
      f.input :can_destroy
      f.input :can_manage
      f.input :can_extras
      f.input :can_read_restricted
      f.input :can_export_to_academic_system
    end
    f.actions
  end
end
