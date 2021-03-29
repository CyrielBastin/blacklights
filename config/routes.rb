Rails.application.routes.draw do

  devise_for :users
  namespace :admin do
    root to: 'dashboards#index'

    concern :paginatable do
      get '(page/:page)', action: :index, on: :collection, as: ''
    end

    resources :users, concerns: :paginatable do
      get "invite"
    end
    resources :locations, concerns: :paginatable
    resources :events, concerns: :paginatable
    resources :equipment, concerns: :paginatable
    resources :suppliers, concerns: :paginatable
    resources :registrations, concerns: :paginatable
    get '/json/location_activities/:loc_id', to: 'activities#location_activities_json'
    resources :activities, concerns: :paginatable
    resources :categories, concerns: :paginatable
  end

  root to: 'public#index'

  get "activities", to: "public#activities"
  get "events", to: "public#events"
  get "about", to: "public#about"
  get "contact", to: "public#contact"
end
