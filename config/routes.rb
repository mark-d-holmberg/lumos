Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # JSON API
  namespace :api, path: "api" do
    namespace :v1 do
      resources :districts, only: [:index] do
        resources :schools, only: [:index] do
          resources :campaigns, only: [:index]
        end
      end
    end
  end

  # Master Backend
  constraints(subdomain: /master/) do
    # Setup Devise Authentication
    devise_for :users, path: 'u', controllers: { sessions: "master/sessions" }

    # Master AJAX backend controllers
    namespace :master_ajax do
      # School based campaigns AJAX controller
      resources :schools, only: [] do
        resources :campaigns, only: [:new, :create], to: 'schools/campaigns'
      end

      # Teacher based campaigns AJAX controller
      resources :teachers, only: [] do
        resources :campaigns, only: [:new, :create], to: 'teachers/campaigns'
      end
    end

    # Master scope
    scope module: 'master' do
      # For adding new devise users the hard way
      resources :users
      resources :products

      resources :states do
        resources :districts
      end

      resources :districts, only: [] do
        resources :schools
      end

      resources :schools do
        resources :teachers
      end

      resources :campaigns, param: 'slug', except: [:new, :create] do
        resources :impressions
      end

      # Importing data
      resources :imports, only: [] do
        collection do
          match :schools, via: [:get, :post]
        end
      end

      # TODO: make this nested
      resources :contributors
      resources :contributions
      resource :tos, only: [:show, :edit, :update]

      # Searching
      resources :searches, only: [:index]

      match '/', to: 'campaigns#index', via: [:get], as: :master_root
    end
  end

  # The frontend
  constraints(subdomain: /landing/) do
    # Creating new teachers on the fly
    resources :schools, only: [] do
      resources :teachers, only: [:new, :create]
    end

    resources :campaigns, only: [], param: 'slug' do
      collection do
        match :new, via: [:get], as: :landing_new, path: 'new'
        match :create, via: [:post]
      end
      member do
        match :show, via: [:get], as: :landing
        match :partner, via: [:get]
        match :reports, via: [:get]
        match :contributions, via: [:get]
        match :thank_you, via: [:get, :post]
      end
      resources :impressions, only: [:create], as: :landing_impressions
    end
  end

  # You can have the root of your site routed with "root"
  root 'public#index'

end
