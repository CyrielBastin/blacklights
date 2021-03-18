Rails.application.routes.draw do

  devise_for :users
  namespace :admin do
    root to: 'dashboards#index'

    concern :paginatable do
      get '(page/:page)', action: :index, on: :collection, as: ''
    end

    resources :users, concerns: :paginatable
    resources :locations, concerns: :paginatable
    get 'previous_events', to: 'events#previous_events'
    resources :events, concerns: :paginatable
    resources :equipment, concerns: :paginatable
    resources :suppliers, concerns: :paginatable
    resources :registrations, concerns: :paginatable
    get '/json/location_activities/:loc_id', to: 'activities#location_activities_json'
    resources :activities, concerns: :paginatable
    resources :categories, concerns: :paginatable
  end

  root to: 'public#index'
end
