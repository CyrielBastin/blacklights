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
    get 'models_import_locations', to: 'locations#import_model'
    resources :events, concerns: :paginatable
    get 'models_import_events', to: 'events#import_model'
    resources :equipment, concerns: :paginatable
    get 'models_import_equipment', to: 'equipment#import_model'
    resources :suppliers, concerns: :paginatable
    get 'models_import_suppliers', to: 'suppliers#import_model'
    resources :registrations, concerns: :paginatable
    get '/json/location_activities/:loc_id', to: 'activities#location_activities_json'
    resources :activities, concerns: :paginatable
    get 'models_import_activities', to: 'activities#import_model'
    resources :categories, concerns: :paginatable
    get 'models_import_categories', to: 'categories#import_model'
    get 'models_import_all', to: 'dashboards#import_models'
  end

  root to: 'public#index'
end
