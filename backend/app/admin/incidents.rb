ActiveAdmin.register Incident do
  menu label: 'Ocorrências'

  permit_params :student_id, :user_id, :institution, :description, :date_incident,
                :soluction, :course_id, :time_incident, :assistant_id, :signed_in,
                :is_resolved, :type_student, :sanction, :school_group_id,
                :type_incident_id, :sector_id, :visibility,
                prohibition_and_responsibility_ids: [], student_duty_ids: []

  index do
    selectable_column
    id_column
    column :student
    column :date_incident
    column :course
    column :type_incident
    column :sanction do |incident|
      I18n.t("activerecord.attributes.incident.sanction.#{incident.sanction}", default: 'Sem sanção')
    end
    column :is_resolved
    column :sector_id
    column :visibility
    actions
  end

  filter :student
  filter :course
  filter :type_incident
  filter :date_incident
  filter :sanction
  filter :is_resolved
  filter :sector_id, as: :select, collection: Sector.order(:name).pluck(:name, :id)
  filter :visibility

  form do |f|
    f.inputs 'Ocorrência' do
      f.input :student
      f.input :user
      f.input :assistant
      f.input :course
      f.input :school_group
      f.input :type_incident
      f.input :sector_id, label: 'Setor', as: :select, collection: Sector.order(:name).pluck(:name, :id)
      f.input :institution
      f.input :description
      f.input :date_incident
      f.input :time_incident
      f.input :soluction
      f.input :is_resolved
      f.input :type_student
      f.input :sanction
      f.input :visibility
      f.input :signed_in
      f.input :prohibition_and_responsibilities
      f.input :student_duties
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :student
      row :user
      row :assistant
      row :course
      row :school_group
      row :type_incident
      row :sector
      row :institution
      row :description
      row :date_incident
      row :time_incident
      row :soluction
      row :is_resolved
      row :type_student
      row :sanction do |incident|
        I18n.t("activerecord.attributes.incident.sanction.#{incident.sanction}", default: 'Sem sanção')
      end
      row :visibility
      row :signed_in
      row :prohibition_and_responsibilities
      row :student_duties
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
