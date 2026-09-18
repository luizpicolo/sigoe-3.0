# frozen_string_literal: true

class Api::CoursesController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!
  before_action :set_course, only: %i[show update destroy]

  def index
    authorize! :read, Course

    params[:return] = params[:amount] if params[:amount].present? && params[:return].blank?
    @courses = Course.where(set_polo)
                     .includes(:polo)
                     .order("#{set_order}": :desc)
                     .search(params[:search])
                     .page(params[:page]).per(set_amount_return)

    total = Course.where(set_polo).search(params[:search]).count
    render json: { courses: @courses.map { |course| course_json(course) }, total: total }
  end

  def show
    authorize! :read, Course

    render json: { course: course_json(@course) }
  end

  def create
    authorize! :create, Course

    @course = Course.new(course_params)

    if @course.save
      render json: { course: course_json(@course) }, status: :created
    else
      render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, Course

    if @course.update(course_params)
      render json: { course: course_json(@course) }
    else
      render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, Course

    if @course.destroy
      head :no_content
    else
      render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:name, :initial, :polo_id)
  end

  def course_json(course)
    course.as_json(only: %i[id name initial polo_id], include: { polo: { only: %i[id name] } })
  end
end
