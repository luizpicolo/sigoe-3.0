# frozen_string_literal: true

class Api::StudentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!
  before_action :set_student, only: %i[show update]

  # GET /api/students
  def index
    authorize! :read, Student

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
    authorize! :read, Student
    render json: { student: student_json(@student, detailed: true) }
  end

  # POST /api/students
  def create
    authorize! :create, Student
    student = Student.new(student_params)

    if student.save
      render json: { student: student_json(student, detailed: true) }, status: :created
    else
      render json: { errors: student.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/students/:id
  def update
    authorize! :update, Student
    attributes = student_params
    attributes = check_password(attributes)

    if @student.update(attributes)
      render json: { student: student_json(@student, detailed: true) }
    else
      render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/students/options
  def options
    authorize! :read, Student
    courses = Course.where(set_polo).order(:name)
    school_groups = SchoolGroup.where(polo_id: courses.select(:polo_id)).order(:identifier, :name)

    render json: {
      courses: courses.as_json(only: %i[id name initial]),
      school_groups: school_groups.as_json(only: %i[id name identifier polo_id]),
      course_situations: Student.course_situations.keys
    }
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
      :password_confirmation,
      :ra,
      :enrollment,
      :course_situation,
      :course_id,
      :school_group_id
    )
  end

  def params_return
    return {} if set_polo.empty?

    { courses: set_polo }
  end
end
