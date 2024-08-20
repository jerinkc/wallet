Rails.application.routes.draw do

  resources :loans

  resource :account_summary, only: [:show], controller: 'account_summary'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'account_summary#show'
end
