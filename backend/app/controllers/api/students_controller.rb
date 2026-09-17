# frozen_string_literal: true

class Api::StudentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!
  before_action :set_student, only: :show

  # GET /api/students
  def index
    students = Student.joins(:course)
                      .where(params_return)
                      .order("#{set_order}": :desc)
                      .search(params[:search])
                      .page(params[:page])
                      .per(set_amount_return)

    render json: {
      students: students.as_json(
        only: %i[id name ra enrollment photo course_situation],
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
      ),
      total: students.total_count
    }
  end

  # GET /api/students/:id
  def show
    render json: {
      student: @student.as_json(
        only: %i[id name cpf birth_date responsible responsible_contact contact ra enrollment course_situation created_at updated_at photo],
        methods: :course_situation,
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
    }
  end

  private

  def set_student
    @student = Student.includes(course: :polo, school_group: :polo).find(params[:id])
  end

  def params_return
    return {} if set_polo.empty?

    { courses: set_polo }
  end
end
