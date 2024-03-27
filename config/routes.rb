Rails.application.routes.draw do
  get '/get_api_key', to: 'api_keys#get_api_key'
  post 'password/forgot', to: 'passwords#forgot'
  post 'password/reset', to: 'passwords#reset'

  devise_for :users, path: '', path_names:
  {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, controllers:
  {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :events, only: %i[create index show update destroy], defaults: { format: 'json' } do
    member do
      put 'update_activation'
      put 'update_close'
    end
  end

  resources :tickets, only: %i[create index update destroy], defaults: { format: 'json' } do
    member do
      put 'transfer_ticket'
      put 'validate_ticket'
    end
  end
  resources :members, only: %i[create index destroy], defaults: { format: 'json' }
  resources :users, only: %i[index], defaults: { format: 'json' }
end
