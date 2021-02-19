Rails.application.routes.draw do

  devise_for :users
  namespace :admin do
    root to: 'dashboards#index'

    resources :users
    resources :locations
    resources :events
    resources :equipments
    resources :suppliers
    resources :registrations
    resources :activities
  end

  root to: 'public#index'
end
