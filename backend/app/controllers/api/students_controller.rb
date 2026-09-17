# frozen_string_literal: true

class Api::StudentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!
  before_action :set_student, only: %i[show update]

  # GET /api/students
  def index
    students = Student.joins(:course)
                      .where(params_return)
                      .order("#{set_order}": :desc)
                      .search(params[:search])
                      .page(params[:page])
                      .per(set_amount_return)

    render json: {
      students: students.map { |student| student_json(student) },
      total: students.total_count
    }
  end

  # GET /api/students/:id
  def show
    render json: { student: student_json(@student, detailed: true) }
  end

  # PATCH/PUT /api/students/:id
  def update
    attributes = student_params
    attributes = check_password(attributes)

    if @student.update(attributes)
      render json: { student: student_json(@student, detailed: true) }
    else
      render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_student
    @student = Student.includes(course: :polo, school_group: :polo)
                      .where(params_return)
                      .find(params[:id])
  end

  def student_json(student, detailed: false)
    attributes = detailed ? %i[id name cpf birth_date responsible responsible_contact contact ra enrollment course_situation created_at updated_at] : %i[id name ra enrollment course_situation]
    attributes << :photo unless detailed

    data = student.as_json(
      only: attributes,
      methods: detailed ? :course_situation : nil,
      include: {
        course: {
          only: %i[id name initial polo_id],
          include: { polo: { only: %i[id name] } }
        },
        school_group: {
          only: %i[id name identifier polo_id],
          include: { polo: { only: %i[id name] } }
        }
      }
    )

    data['photo'] = photo_url(student)
    data
  end

  def photo_url(student)
    photo = student.photo.to_s
    return nil if photo.empty?
    return photo if photo.start_with?('http://', 'https://')

    "#{request.base_url}#{photo.start_with?('/') ? '' : '/'}#{photo}"
  end

  def check_password(attributes)
    if attributes[:password].blank?
      attributes.delete(:password)
      attributes.delete(:password_confirmation)
    end
    attributes
  end

  def student_params
    params.require(:student).permit(
      :name,
      :cpf,
      :birth_date,
      :responsible,
      :responsible_contact,
      :contact,
      :password,
      :password_confirmation
    )
  end

  def params_return
    return {} if set_polo.empty?

    { courses: set_polo }
  end
end
