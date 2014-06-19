Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # JSON API
  constraints(subdomain: /api/) do
    namespace :api, path: "" do
      namespace :v1 do
        # TODO: nesting?
        resources :districts, only: [:index]
        resources :schools, only: [:index]
        resources :campaigns, only: [:index]
      end
    end
  end

  # Master Backend
  constraints(subdomain: /master/) do
    # Setup Devise Authentication
    devise_for :users, path: 'u', controllers: { sessions: "master/sessions" }

    # Master scope
    scope module: 'master' do
      # For adding new devise users the hard way
      resources :users

      resources :states
      resources :districts
      resources :schools
      resources :teachers
      resources :campaigns

      # TODO: make this nested
      resources :contributors
      resources :contributions
      resource :tos, only: [:show, :edit, :update]

      match '/', to: 'campaigns#index', via: [:get], as: :master_root
    end
  end

  # You can have the root of your site routed with "root"
  root 'public#index'

end
