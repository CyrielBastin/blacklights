Rails.application.routes.draw do

  devise_for :users
  namespace :admin do
    root to: 'dashboards#index'

    concern :paginatable do
      get '(page/:page)', action: :index, on: :collection, as: ''
    end

    resources :users, concerns: :paginatable do
      get 'invite'
    end
    resources :locations, concerns: :paginatable
    post 'import_locations', to: 'locations#import'
    resources :events, concerns: :paginatable
    post 'import_events', to: 'events#import'
    post 'import_event_registrations', to: 'events#import_registrations_per_event'
    resources :equipment, concerns: :paginatable
    post 'import_equipment', to: 'equipment#import'
    resources :suppliers, concerns: :paginatable
    post 'import_suppliers', to: 'suppliers#import'
    resources :registrations, concerns: :paginatable do
      post 'confirm'
    end
    post 'import_registrations', to: 'registrations#import'
    get '/json/location_activities/:loc_id', to: 'activities#location_activities_json'
    resources :activities, concerns: :paginatable
    post 'import_activities', to: 'activities#import'
    resources :categories, concerns: :paginatable
    post 'import_categories', to: 'categories#import'
    post 'import_all', to: 'dashboards#import'
  end

  root to: 'public#index'

  resources :activities
  resources :events
  get "events", to: "public#events"
  get "about", to: "public#about"
  get "contact", to: "public#contact"
end
