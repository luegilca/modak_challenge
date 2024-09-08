Rails.application.routes.draw do
  resources :notifications
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  scope :users do
    get '/', to: 'users#index'
    post '/', to: 'users#create'
    get '/:id', to: 'users#show'
    patch '/:id', to: 'users#update'
    delete '/:id', to: 'users#destroy'
  end

  scope :notifications do
    get '/', to: 'notifications#index'
    post '/', to: 'notifications#create'
    post '/send', to: 'notifications#send_notification'
    get '/:id', to: 'notifications#show'
    patch '/:id', to: 'notifications#update'
    delete '/:id', to: 'notifications#destroy'
  end
end
