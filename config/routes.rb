# frozen_string_literal: true

Rails.application.routes.draw do
  resources :controlled_vocabularies
  resources :conservation_records do
    resources :in_house_repair_records
    resources :external_repair_records
  end
  root 'front#index'
  get 'front/index'
  devise_for :users
end
