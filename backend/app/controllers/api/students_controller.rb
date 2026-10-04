# frozen_string_literal: true

class Api::StudentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!
  before_action :set_student, only: %i[show update destroy]

  def index
    authorize! :read, Student

    students = campus_scope(Student).includes(course: :polo, school_group: :polo)
                      .where(course_situation: 5)
                      .order("#{set_order}": :desc)
                      .search(params[:search])
                      .page(params[:page])
                      .per(set_amount_return)

    render json: {
      students: students.map { |student| student_json(student) },
      total: students.total_count
    }
  end

  def show
    authorize! :read, Student
    render json: { student: student_json(@student, detailed: true) }
  end

  def create
    authorize! :create, Student
    student = Student.new(student_params)

    if student.save
      render json: { student: student_json(student, detailed: true) }, status: :created
    else
      render json: { errors: student.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    authorize! :update, Student
    attributes = check_password(student_params)

    if @student.update(attributes)
      render json: { student: student_json(@student, detailed: true) }
    else
      render json: { errors: @student.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    authorize! :destroy, Student
    @student.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { errors: [e.message] }, status: :unprocessable_content
  end

  def options
    authorize! :read, Student
    courses = campus_scope(Course).order(:name)
    school_groups = SchoolGroup.where(polo_id: courses.select(:polo_id)).order(:identifier, :name)

    render json: {
      courses: courses.as_json(only: %i[id name initial]),
      school_groups: school_groups.as_json(only: %i[id name identifier polo_id]),
      course_situations: Student.course_situations.keys
    }
  end

  private

  def set_student
    @student = campus_scope(Student).includes(course: :polo, school_group: :polo).find(params[:id])
  end

  def student_json(student, detailed: false)
    attributes = detailed ? %i[id name cpf birth_date responsible responsible_contact contact ra enrollment course_situation created_at updated_at] : %i[id name ra enrollment course_situation]
    attributes << :photo unless detailed

    data = student.as_json(only: attributes, methods: detailed ? :course_situation : nil, include: { course: { only: %i[id name initial polo_id], include: { polo: { only: %i[id name] } } }, school_group: { only: %i[id name identifier polo_id], include: { polo: { only: %i[id name] } } } })
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
    attributes = params.require(:student).permit(:name, :cpf, :birth_date, :responsible, :responsible_contact, :contact, :password, :password_confirmation, :ra, :enrollment, :course_situation, :course_id, :school_group_id)
    validate_campus_links!(attributes, course_id: Course, school_group_id: SchoolGroup)
  end

  def params_return
    return {} if set_polo.empty?

    { courses: set_polo }
  end
end
