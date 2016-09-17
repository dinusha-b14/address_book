Rails.application.routes.draw do
  resources :contacts
  namespace :batch do
    resources :contacts, only: [:new, :create, :show]
  end
  root 'contacts#index'
end
