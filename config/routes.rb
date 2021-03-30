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
    get 'import_locations', to: 'locations#import'
    resources :events, concerns: :paginatable
    get 'import_events', to: 'events#import'
    resources :equipment, concerns: :paginatable
    get 'import_equipment', to: 'equipment#import'
    resources :suppliers, concerns: :paginatable
    get 'import_suppliers', to: 'suppliers#import'
    resources :registrations, concerns: :paginatable
    get '/json/location_activities/:loc_id', to: 'activities#location_activities_json'
    resources :activities, concerns: :paginatable
    get 'import_activities', to: 'activities#import'
    resources :categories, concerns: :paginatable
    get 'import_categories', to: 'categories#import'
    get 'import_all', to: 'dashboards#import'
  end

  root to: 'public#index'

  get "activities", to: "public#activities"
  get "events", to: "public#events"
  get "about", to: "public#about"
  get "contact", to: "public#contact"
end
