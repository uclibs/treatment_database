Rails.application.routes.draw do
  root 'front#index'
  get 'front/index'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
