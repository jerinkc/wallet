Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resource :account_summary, only: [:show], controller: 'account_summary'

  root to: 'account_summary#show'
end
