Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "home#show"

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :attempts

  namespace :grading do
    resources :cohorts do
      get '/attempts', to: 'attempts#index'
      get '/students', to: 'students#index'
      post '/enrollment', to: 'enrollment#update'
      post '/preview_as_student', to: 'student_preview_mode#enter'
    end
    resources :students, only: [:show, :update]
    resources :attempts, only: [:show, :update]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
