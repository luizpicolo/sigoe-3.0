class Api::UsersController < ApplicationController
  include ParamsSearch
  before_action :authenticate_user!

  # GET /api/users
  def index
    users = User.where(set_polo)
                .order("#{set_order}": :asc)
                .search(params[:search])
                .page(params[:page])

    render json: {
      users: users.as_json(include: User.reflect_on_all_associations.map(&:name), except: [:password, :created_at]),
      total: users.total_count
    }
  end

  def validation
    user = get_user_from_token

    if user
      render json: {
        message: "If you see this, you're in!",
        user: user
      }, status: :ok
    else
      render json: { error: 'Token inválido ou ausente' }, status: :unauthorized
    end
  end

  private

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
