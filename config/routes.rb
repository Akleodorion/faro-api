Rails.application.routes.draw do
  get '/get_api_key', to: 'api_keys#get_api_key'
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

  resources :events, only: %i[create index show update destroy] do
    member do
      put 'update_activation'
      put 'update_close'
    end
  end
  resources :tickets, only: %i[create index update destroy]
  resources :members, only: %i[create index destroy]
  resources :users, only: %i[index]
end
