# frozen_string_literal: true

Rails.application.routes.draw do
  # Shibboleth authentication and sessions
  resources :sessions, only: %i[new create destroy]
  delete 'logout', to: 'sessions#destroy', as: :logout
  get 'auth/shibboleth/callback', to: 'sessions#shibboleth_callback', as: :shibboleth_callback

  # Development authentication and sessions
  if Rails.env.development? || Rails.env.test?
    resources :dev_sessions, only: %i[new create destroy]
    delete 'dev_logout', to: 'dev_sessions#destroy', as: :dev_logout
  end

  # Admin namespace for managing users
  namespace :admin do
    resources :users # Admins can manage users (CRUD)
  end

  # User management (handled outside admin, excluding create)
  resources :users, only: %i[edit update show]

  # Resources that require detailed management and associations
  resources :conservation_records do
    resources :in_house_repair_records
    resources :external_repair_records
    resources :con_tech_records
    resources :treatment_reports
    resources :abbreviated_treatment_reports
    resources :cost_return_reports
  end

  # Miscellaneous resource routes
  resources :staff_codes, except: [:destroy]
  resources :reports do
    get 'download_csv', on: :collection
  end
  resources :controlled_vocabularies, except: [:destroy]
  resources :activity

  # Search routes
  get 'search/help'
  get 'search', to: 'search#results', as: 'search'

  # Root and front routes
  root 'front#index'
  get 'front/index'

  # Conservation records-specific actions
  get 'conservation_records/:id/conservation_worksheet', to: 'conservation_records#conservation_worksheet', as: 'conservation_worksheet'
  get 'conservation_records/:id/treatment_report', to: 'conservation_records#treatment_report', as: 'treatment_report'
  get 'conservation_records/:id/abbreviated_treatment_report', to: 'conservation_records#abbreviated_treatment_report', as: 'abbreviated_treatment_report'
end
