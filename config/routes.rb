Rails.application.routes.draw do

  devise_for :users
  namespace :admin do
    root to: 'dashboards#index'

    resources :users
    resources :locations
    resources :events
    resources :equipment
    resources :suppliers
    resources :registrations
    resources :activities
    resources :categories
  end

  root to: 'public#index'
end
