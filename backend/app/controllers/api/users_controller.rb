class Api::UsersController < ApplicationController
  include ParamsSearch

  before_action :authenticate_user!

  def index
    authorize! :read, User

    users = User.where(set_polo)
                .order("#{set_order}": :desc)
                .search(params[:search])
                .page(params[:page])

    render json: {
      users: users.as_json(
        include: User.reflect_on_all_associations.map(&:name),
        except: [:password, :created_at]
      ),
      total: users.total_count
    }
  end

  def show
    authorize! :read, User

    user = User.find(params[:id])

    render json: {
      user: user.as_json(
        include: User.reflect_on_all_associations.map(&:name),
        except: [:password, :created_at]
      )
    }
  end

  def create
    authorize! :create, User

    user = User.new(user_params)

    if user.save
      render json: {
        user: user.as_json(except: [:encrypted_password, :reset_password_token])
      }, status: :created
    else
      render json: {
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, User

    user = User.find(params[:id])

    attributes = params.require(:user).permit(
      :name,
      :email,
      :username,
      :siape,
      :polo_id,
      :admin,
      :status,
      :password,
      :password_confirmation,
      :avatar
    )

    attributes.delete(:password) if attributes[:password].blank?
    attributes.delete(:password_confirmation) if attributes[:password_confirmation].blank?

    user.update!(attributes)

    render json: {
      user: user
    }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      errors: e.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  def change_password
    current_password = params.require(:current_password)
    new_password = params.require(:new_password)
    password_confirmation = params.require(:password_confirmation)

    unless current_user.valid_password?(current_password)
      render json: {
        error: 'A senha atual está incorreta.'
      }, status: :unprocessable_entity

      return
    end

    unless new_password == password_confirmation
      render json: {
        error: 'A confirmação da senha não corresponde.'
      }, status: :unprocessable_entity

      return
    end

    if current_user.update(
      password: new_password,
      password_confirmation: password_confirmation
    )
      render json: {
        message: 'Senha alterada com sucesso.'
      }, status: :ok
    else
      render json: {
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, User

    user = User.find(params[:id])

    if user.id == current_user.id
      return render json: {
        error: 'Não é possível excluir o próprio usuário'
      }, status: :unprocessable_entity
    end

    user.destroy!

    head :no_content
  end

  def options
    authorize! :read, User
    if current_user.super_admin 
      polos = Polo.order(:name)
    else
      polos = Polo.where(id: current_user.polo_id).order(:name)
    end
    render json: { polos: polos.as_json(only: %i[id name]) }
  end

  def validation
    user = get_user_from_token

    if user
      render json: {
        message: "If you see this, you're in!",
        user: user
      }, status: :ok
    else
      render json: {
        error: 'Token inválido ou ausente'
      }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :siape,
      :username,
      :email,
      :password,
      :password_confirmation,
      :status,
      :avatar,
      :course_id,
      :admin,
      :polo_id
    )
  end

  def get_user_from_token
    token = request.headers['Authorization']&.split(' ')&.last

    return nil if token.blank?

    jwt_payload, = JWT.decode(
      token,
      Rails.application.credentials.jwt_secret_key,
      true,
      { algorithm: 'HS256' }
    )

    User.find_by(id: jwt_payload['sub'])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    nil
  end
end