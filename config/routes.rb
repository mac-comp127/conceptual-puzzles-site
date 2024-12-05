Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "home#show"

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :attempts

  namespace :grading do
    resources :cohorts do
      get '/', to: 'home#show'

      get '/attempts', to: 'attempts#index'
      get '/students', to: 'students#index'
    end
    resources :students, only: [:show]
    resources :attempts, only: [:show, :update]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
