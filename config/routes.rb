Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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

      match '/', to: 'dashboard#index', via: [:get], as: :master_root
    end
  end

  # You can have the root of your site routed with "root"
  root 'public#index'

end
