# frozen_string_literal: true

class Api::StudentsController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!

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
          course: { only: %i[id name initial] },
          school_group: { only: %i[id name] }
        }
      ),
      total: students.total_count
    }
  end

  private

  def params_return
    return {} if set_polo.empty?

    { courses: set_polo }
  end
end
