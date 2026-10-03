# frozen_string_literal: true

class PermissionsController < ApplicationController
  include ParamsSearch

  before_action :authorize_permission_management!

  load_and_authorize_resource

  before_action :set_permission, only: %i[edit destroy update]
  add_breadcrumb 'Home', :root_path

  def index
    add_breadcrumb 'Administrador'
    add_breadcrumb 'Usuários'

    @permissions = Permission.order("#{set_order}": :desc)
        .search(params[:search])
        .where(user_id: params[:user_id])
        .page(params[:page]).per(set_amount_return)
  end

  def new
    add_breadcrumb 'Administrador'
    add_breadcrumb 'Usuários', :users_path
    add_breadcrumb 'Permissões'

    @permission = Permission.new
  end

  def create
    @permission = Permission.new(permission_params)
    @permission.user_id = params[:user_id]
    if @permission.save
      redirect_to user_permissions_path, flash: { success: 'Permissões cadastradas com sucesso' }
    else
      flash.now[:error] = @permission.errors.full_messages
      render :new
    end
  end

  def edit
    add_breadcrumb 'Administrador'
    add_breadcrumb 'Usuários', :users_path
    add_breadcrumb 'Atualizar Permissões'
  end

  def update
    if @permission.update(permission_params)
      redirect_to user_permissions_path(user_id: @permission.user_id), flash: {
          success: 'Permissões atualizadas com sucesso'
      }
    else
      flash.now[:error] = @permission.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @permission.destroy
      flash[:success] = 'Permissões deletadas com sucesso'
      redirect_back(fallback_location: user_permissions_path)
    else
      flash.now[:error] = @permission.errors.full_messages
      render :destroy
    end
  end

  private

  def authorize_permission_management!
    raise CanCan::AccessDenied unless current_user.admin? || current_user.super_admin?
    @permission_user = scoped_user(params[:user_id], write: true)
  end

  def set_permission
    @permission = @permission_user.permissions.find(params[:id])
  end

  def permission_params
    params.require(:permission).permit(
      :entity, :can_create, :can_read, :can_read_restricted, :can_update, :can_destroy, :can_extras, :can_export_to_academic_system
    )
  end
end
