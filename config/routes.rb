# frozen_string_literal: true

Rails.application.routes.draw do
  resources :staff_codes, except: [:destroy]
  post 'users', to: 'users#create_user'
  resources :reports
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, controller: 'users', except: %i[create show]
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

  get 'search/help'
  get 'search', to: 'search#results', as: 'search'
  root 'front#index'
  get 'front/index'
  get 'conservation_records/:id/conservation_worksheet', to: 'conservation_records#conservation_worksheet', as: 'conservation_worksheet'
  get 'conservation_records/:id/treatment_report', to: 'conservation_records#treatment_report', as: 'treatment_report'
  get 'conservation_records/:id/abbreviated_treatment_report', to: 'conservation_records#abbreviated_treatment_report', as: 'abbreviated_treatment_report'
  get 'reports/download_csv'

  get 'auth/shibboleth/callback', to: 'callbacks#shibboleth', as: :shibboleth_callback
  delete 'logout', to: 'sessions#destroy', as: :logout
end
