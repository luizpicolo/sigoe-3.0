# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: :all
  devise_scope :user do
    post '/api/auth/login', to: 'api/sessions#create', as: :user_session
    delete '/api/auth/logout', to: 'api/sessions#destroy', as: :destroy_user_session
  end

  namespace :api, defaults: { format: :json } do
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
      resources :attachments, only: [:show, :create, :destroy], controller: 'incident_attachments'
    end
    get 'dashboard', to: 'dashboard#show'
  end
end
