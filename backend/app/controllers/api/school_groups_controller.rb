# frozen_string_literal: true

class Api::SchoolGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_school_group, only: %i[show update destroy]

  def index
    authorize! :read, SchoolGroup
    groups = SchoolGroup.includes(:polo).order(:name)
    render json: { school_groups: groups.map { |g| group_json(g) }, total: groups.count }
  end

  def show
    authorize! :read, SchoolGroup
    render json: { school_group: group_json(@school_group) }
  end

  def create
    authorize! :create, SchoolGroup
    group = SchoolGroup.new(group_params)
    if group.save
      render json: { school_group: group_json(group) }, status: :created
    else
      render json: { errors: group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, SchoolGroup
    if @school_group.update(group_params)
      render json: { school_group: group_json(@school_group) }
    else
      render json: { errors: @school_group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, SchoolGroup
    @school_group.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  private

  def set_school_group = @school_group = SchoolGroup.find(params[:id])
  def group_params = params.require(:school_group).permit(:name, :identifier, :polo_id)
  def group_json(group)
    group.as_json(only: %i[id name identifier polo_id], include: { polo: { only: %i[id name] } })
  end
end
