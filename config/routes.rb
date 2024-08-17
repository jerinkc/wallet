Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resource :account_summary, only: [:show]

  root to: 'account_summary#show'
end
