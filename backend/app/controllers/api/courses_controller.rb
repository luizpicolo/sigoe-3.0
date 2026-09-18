# frozen_string_literal: true

class Api::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: %i[show update destroy]

  def index
    authorize! :read, Course
    courses = Course.includes(:polo)
    courses = courses.where('courses.name ILIKE :search OR courses.initial ILIKE :search', search: "%#{params[:search]}%") if params[:search].present?
    order_column = %w[id name].include?(params[:order]) ? params[:order] : 'id'
    total = courses.count
    amount = params[:amount].to_i.clamp(1, 100)
    page = [params[:page].to_i, 1].max
    courses = courses.order(order_column => :asc).offset((page - 1) * amount).limit(amount)
    render json: { courses: courses.map { |c| course_json(c) }, total: total }
  end

  def show
    authorize! :read, Course
    render json: { course: course_json(@course) }
  end

  def create
    authorize! :create, Course
    course = Course.new(course_params)
    if course.save
      render json: { course: course_json(course) }, status: :created
    else
      render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
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
    @course.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  private

  def set_course = @course = Course.find(params[:id])
  def course_params = params.require(:course).permit(:name, :initial, :polo_id)
  def course_json(course)
    course.as_json(only: %i[id name initial polo_id], include: { polo: { only: %i[id name] } })
  end
end
