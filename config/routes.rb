Rails.application.routes.draw do

  devise_for :users
  namespace :admin do
    root to: 'dashboards#index'

    resources :users
    resources :locations
    get '/events/all/previous', to: 'events#previous_events'
    resources :events
    resources :equipment
    resources :suppliers
    resources :registrations
    get '/json/location_activities/:loc_id', to: 'activities#location_activities_json'
    resources :activities
    resources :categories
  end

  root to: 'public#index'
end
