Rails.application.routes.draw do
  namespace :user do
    resources :loans do
      member do
        patch :accept
        patch :reject
        patch :ask_readjustment
      end
    end
  end

  namespace :admin do
    resources :loans do
      member do
        patch :approve
        patch :reject
      end
    end
  end

  resource :account_summary, only: [:show], controller: 'account_summary'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'account_summary#show'
end
