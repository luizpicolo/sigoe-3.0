# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api, defaults: { format: :json } do
    devise_for :user, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', registration: 'register', sign_up: 'signup' }, controllers: { sessions: 'api/sessions', registrations: 'api/registrations' }
    resources :users, only: [:index, :show, :create, :update, :destroy] do
      collection { get :validation }
      collection { get :options }
      collection { put :change_password }
      member do
        get :permissions, to: 'permissions#show'
        put :permissions, to: 'permissions#update'
      end
    end
    resources :permissions, only: [] do
      collection { get :current }
    end
    resources :students, only: [:index, :show, :create, :update, :destroy] do
      collection { get :options }
    end
    resources :courses, only: [:index, :show, :create, :update, :destroy]
    resources :school_groups, only: [:index, :show, :create, :update, :destroy]
    resources :incidents, only: [:index, :show, :create, :update, :destroy] do
      collection { get :options }
    end
    get 'dashboard', to: 'dashboard#show'
    resources :report_incidents, only: [] do
      collection do
        get :options
        get :data
      end
    end
    post 'report_incidents', to: 'report_incidents#create', defaults: { format: :pdf }
  end

end
