# frozen_string_literal: true

Rails.application.routes.draw do
  # Production authentication routes
  get 'login', to: 'sessions#new', as: :login
  delete 'logout', to: 'sessions#destroy', as: :logout
  get 'shibboleth_logout', to: redirect('/Shibboleth.sso/Logout?return=https://libappstest.libraries.uc.edu/treatment_database')

  # Development and testing authentication routes
  if Rails.env.development? || Rails.env.test?
    get 'dev_login', to: 'dev_sessions#new', as: :dev_login
    post 'dev_login', to: 'dev_sessions#create'
    delete 'dev_logout', to: 'dev_sessions#destroy', as: :dev_logout
    get 'shibboleth_login', to: 'test_shibboleth#login'
    get '/test_user_auth', to: 'test_user_authentication#index'
    get '/admin_area', to: 'test_user_authentication#admin_area'
  end

  # Admin Namespace for Managing Users
  namespace :admin do
    resources :users # Admins can manage users (CRUD)
  end

  # User Management (Outside Admin, Excluding Create)
  resources :users, only: %i[edit update show]

  # Conservation Records and Nested Resources
  resources :conservation_records do
    resources :in_house_repair_records
    resources :external_repair_records
    resources :con_tech_records
    resources :treatment_reports
    resources :abbreviated_treatment_reports
    resources :cost_return_reports

    # Conservation Records-Specific Actions
    member do
      get 'conservation_worksheet'
      get 'treatment_report'
      get 'abbreviated_treatment_report'
    end
  end

  # Miscellaneous Resource Routes
  resources :staff_codes, except: [:destroy]
  resources :controlled_vocabularies, except: [:destroy]
  resources :activity
  resources :reports do
    get 'download_csv', on: :collection
  end

  # Search Routes
  get 'search/help', to: 'search#help', as: :search_help
  get 'search', to: 'search#results', as: :search

  # Root and Front Routes
  root 'front#index'
  get 'front/index', to: 'front#index'
end
