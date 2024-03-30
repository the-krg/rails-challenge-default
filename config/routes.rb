Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api, defaults: { format: :json } do
    get '/users', to: 'users#index'
    post '/users', to: 'users#create'
  end

  # Pretend that this endpoint is an external application; made for AccountKeyService
  namespace :account_key_api, defaults: { format: :json } do
    post '/account', to: 'account_keys#create'
  end
end
