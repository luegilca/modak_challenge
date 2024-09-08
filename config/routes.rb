Rails.application.routes.draw do
  resources :notifications
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  scope :users do
    get '/', to: 'users#index', as: :get_all_users
    post '/', to: 'users#create', as: :create_users
    get '/:id', to: 'users#show', as: :get_users
    patch '/:id', to: 'users#update', as: :update_users
    delete '/:id', to: 'users#destroy', as: :delete_users
  end

  scope :notifications do
    get '/', to: 'notifications#index', as: :get_all_notifications
    post '/', to: 'notifications#create', as: :create_notifications
    post '/send', to: 'notifications#send_notification', as: :send_notifications
    get '/:id', to: 'notifications#show', as: :get_notifications
    patch '/:id', to: 'notifications#update', as: :update_notifications
    delete '/:id', to: 'notifications#destroy', as: :destroy_notifications
  end
end
