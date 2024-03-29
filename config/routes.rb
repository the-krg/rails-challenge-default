Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api, defaults: { format: :json } do
    get '/users', to: 'users#index'
    post '/users', to: 'users#create'
  end
end
