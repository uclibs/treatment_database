# frozen_string_literal: true

Rails.application.routes.draw do
  root 'front#index'

  # Custom routes for session management
  get 'login', to: 'sessions#new', as: :login
  delete 'logout', to: 'sessions#destroy', as: :logout

  # OmniAuth callback route
  match '/auth/:provider/callback', to: 'callbacks#shibboleth', via: [:get, :post]
  get 'auth/failure', to: redirect('/')

  # Custom routes for user registration and settings
  get 'signup', to: 'users#new', as: :signup
  post 'signup', to: 'users#create', as: :create_user
  get 'user/settings', to: 'users#settings', as: :user_settings

  # Resource routes for users
  resources :users, except: %i[new create show]

  # Other resource routes
  resources :staff_codes, except: [:destroy]
  resources :reports
  resources :controlled_vocabularies, except: [:destroy]
  resources :activity

  resources :conservation_records do
    resources :in_house_repair_records
    resources :external_repair_records
    resources :con_tech_records
    resources :treatment_reports
    resources :abbreviated_treatment_reports
    resources :cost_return_reports
  end

  # Search routes
  get 'search/help'
  get 'search', to: 'search#results', as: 'search'

  # Front controller routes
  get 'front/index'
  get 'conservation_records/:id/conservation_worksheet', to: 'conservation_records#conservation_worksheet', as: 'conservation_worksheet'
  get 'conservation_records/:id/treatment_report', to: 'conservation_records#treatment_report', as: 'treatment_report'
  get 'conservation_records/:id/abbreviated_treatment_report', to: 'conservation_records#abbreviated_treatment_report', as: 'abbreviated_treatment_report'
  get 'reports/download_csv'
end
