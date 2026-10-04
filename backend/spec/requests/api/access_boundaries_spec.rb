require 'rails_helper'

RSpec.describe 'Campus and privacy boundaries', type: :request do
  let!(:polo) { create(:polo) }
  let!(:other_polo) { create(:polo) }
  let!(:actor) { create(:user, polo: polo) }
  let!(:colleague) { create(:user, polo: polo) }
  let!(:outsider) { create(:user, polo: other_polo) }
  let!(:course) { create(:course, polo: polo) }
  let!(:other_course) { create(:course, polo: other_polo) }
  let!(:student) { create(:student, course: course) }
  let!(:other_student) { create(:student, course: other_course) }

  before { sign_in actor, scope: :user }

  def grant(entity, **actions)
    create(:permission, user: actor, entity: entity, **actions)
  end

  def incident_for(owner, visibility: 'public', course: self.course)
    create(:incident, user: owner, assistant: colleague, student: student,
                      course: course, visibility: visibility)
  end

  describe 'users and delegated permissions' do
    before { grant('User', can_read: true, can_update: true, can_create: true, can_destroy: true) }

    it 'rejects self-promotion and leaves the account unchanged' do
      patch "/api/users/#{actor.id}", params: { user: { admin: true } }
      expect(response).to have_http_status(:forbidden)
      expect(actor.reload).not_to be_admin
    end

    it 'rejects creating an administrator through a delegated create permission' do
      expect do
        post '/api/users', params: { user: attributes_for(:user).merge(admin: true) }
      end.not_to change(User, :count)
      expect(response).to have_http_status(:forbidden)
    end

    it 'allows ordinary local edits' do
      patch "/api/users/#{colleague.id}", params: { user: { name: 'Updated' } }
      expect(response).to have_http_status(:ok)
      expect(colleague.reload.name).to eq('Updated')
    end

    it 'prevents taking over an administrator by resetting their password' do
      colleague.update!(admin: true)
      patch "/api/users/#{colleague.id}", params: { user: { password: 'new-password', password_confirmation: 'new-password' } }
      expect(response).to have_http_status(:forbidden)
      expect(colleague.reload.valid_password?('new-password')).to be(false)
    end

    %i[get patch delete].each do |verb|
      it "blocks #{verb} of a user outside the campus" do
        public_send(verb, "/api/users/#{outsider.id}", params: { user: { name: 'Tampered' } })
        expect(response).to have_http_status(:not_found)
        expect(outsider.reload.name).not_to eq('Tampered')
      end
    end

    it 'rejects changing campus' do
      patch "/api/users/#{colleague.id}", params: { user: { polo_id: other_polo.id } }
      expect(response).to have_http_status(:forbidden)
      expect(colleague.reload.polo_id).to eq(polo.id)
    end

    it 'returns 403 for permission management by an ordinary user, without changing permissions' do
      get "/api/users/#{colleague.id}/permissions"
      expect(response).to have_http_status(:forbidden)
      expect do
        put "/api/users/#{colleague.id}/permissions", params: { permissions: [{ entity: 'users', can_update: true }] }
      end.not_to change(Permission, :count)
      expect(response).to have_http_status(:forbidden)
    end

    it 'keeps campus administrators from managing another campus or a super administrator' do
      actor.update!(admin: true)
      get "/api/users/#{outsider.id}/permissions"
      expect(response).to have_http_status(:not_found)
      colleague.update!(super_admin: true)
      patch "/api/users/#{colleague.id}", params: { user: { password: 'new-password' } }
      expect(response).to have_http_status(:forbidden)
    end

    it 'allows a super administrator to access another campus' do
      actor.update!(super_admin: true)
      get "/api/users/#{outsider.id}"
      expect(response).to have_http_status(:ok)
    end

  end

  describe 'incident visibility' do
    let!(:own_private) { incident_for(actor, visibility: 'private') }
    let!(:other_private) { incident_for(colleague, visibility: 'private') }
    let!(:public_incident) { incident_for(colleague) }
    let!(:foreign_incident) { incident_for(outsider, course: other_course) }
    before { grant('Incident', can_read: true, can_update: true, can_destroy: true) }

    it 'lists only public or owned records in the same campus' do
      get '/api/incidents'
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['incidents'].map { |item| item['id'] }).to contain_exactly(own_private.id, public_incident.id)
    end

    %i[get patch delete].each do |verb|
      it "does not expose another author's private occurrence through #{verb}" do
        public_send(verb, "/api/incidents/#{other_private.id}", params: { incident: { description: 'Tampered' } })
        expect(response).to have_http_status(:not_found)
        expect(other_private.reload.description).not_to eq('Tampered')
      end
    end

    it 'applies restricted read to lists and direct URLs' do
      actor.permissions.update_all(can_read_restricted: true)
      get '/api/incidents'
      expect(response.parsed_body['incidents'].map { |item| item['id'] }).to eq([own_private.id])
      get "/api/incidents/#{public_incident.id}"
      expect(response).to have_http_status(:not_found)
    end

    it 'excludes private and foreign records from dashboard totals' do
      get '/api/dashboard'
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['by_years'].values.sum).to eq(2)
    end

    it 'keeps private records hidden from a local administrator but allows super administrators' do
      actor.update!(admin: true)
      get "/api/incidents/#{other_private.id}"
      expect(response).to have_http_status(:not_found)
      actor.update!(super_admin: true)
      get "/api/incidents/#{other_private.id}"
      expect(response).to have_http_status(:ok)
    end

    it 'honors the requested page size' do
      get '/api/incidents', params: { amount: 1 }
      expect(response.parsed_body['incidents'].length).to eq(1)
      expect(response.parsed_body['total']).to eq(2)
    end

    it 'serves PDFs only after authorizing the occurrence, outside public/' do
      attachment = create(:incident_attachment, incident: own_private)
      expect(attachment.file.path).to start_with(Rails.root.join('storage').to_s)
      get "/api/incidents/#{own_private.id}/attachments/#{attachment.id}"
      expect(response).to have_http_status(:ok)
      expect(response.headers['Cache-Control']).to include('no-store')
      sign_in colleague, scope: :user
      create(:permission, user: colleague, entity: 'Incident', can_read: true)
      get "/api/incidents/#{own_private.id}/attachments/#{attachment.id}"
      expect(response).to have_http_status(:not_found)
      sign_out :user
      get "/api/incidents/#{own_private.id}/attachments/#{attachment.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'other campus resources' do
    before { actor.update!(admin: true) }

    { 'courses' => :course, 'school_groups' => :school_group }.each do |resource, factory|
      %i[get patch delete].each do |verb|
        it "rejects #{verb} of foreign #{resource}" do
          record = create(factory, polo: other_polo)
          public_send(verb, "/api/#{resource}/#{record.id}", params: { factory => { name: 'Tampered' } })
          expect(response).to have_http_status(:not_found)
          expect(record.reload.name).not_to eq('Tampered')
        end
      end

      it "rejects creating #{resource} in another campus" do
        post "/api/#{resource}", params: { factory => { name: 'New', initial: 'N', identifier: 'N', polo_id: other_polo.id } }
        expect(response).to have_http_status(:forbidden)
      end
    end

    it 'rejects moving a student to another campus through a course or class ID' do
      foreign_group = create(:school_group, polo: other_polo)
      [{ course_id: other_course.id }, { school_group_id: foreign_group.id }].each do |attributes|
        patch "/api/students/#{student.id}", params: { student: attributes }
        expect(response).to have_http_status(:not_found)
      end
      expect(student.reload.course_id).to eq(course.id)
    end
  end

  describe 'incident creation' do
    let(:payload) do
      { student_ids: [student.id], assistant_id: colleague.id, description: 'Occurrence',
        date_incident: Date.current.to_s, time_incident: '10:00', visibility: 'public',
        type_incident_id: create(:type_incident).id }
    end
    before { grant('Incident', can_create: true) }

    it 'creates local records with the authenticated author and student course' do
      post '/api/incidents', params: { incident: payload }
      expect(response).to have_http_status(:created)
      expect(Incident.last.user_id).to eq(actor.id)
      expect(Incident.last.course_id).to eq(course.id)
    end

    it 'rolls back the entire batch if one student is outside the campus' do
      expect do
        post '/api/incidents', params: { incident: payload.merge(student_ids: [student.id, other_student.id]) }
      end.not_to change(Incident, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'rejects an assistant from another campus' do
      expect do
        post '/api/incidents', params: { incident: payload.merge(assistant_id: outsider.id) }
      end.not_to change(Incident, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'rejects an empty selection instead of returning a server error' do
      post '/api/incidents', params: { incident: payload.except(:student_ids) }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
