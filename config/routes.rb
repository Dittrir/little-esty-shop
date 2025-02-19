Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
#heroku welcome page
root 'welcome#index'

get '/merchants/:merchant_id/dashboard', to: 'merchants#dashboard'
patch '/merchants/:merchant_id/bulk_discounts/:id/edit', to: 'bulk_discounts#update'

  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index, :show]
    resources :items
    resources :invoices, only: [:index, :show]
    resources :invoice_items, only: :update
    resources :bulk_discounts
  end

  namespace :admin do
    root to: '/admin#index'
    resources :merchants, only: [:index, :show, :edit, :update, :new, :create]
    resources :invoices, only: [:index, :show, :update]
  end

  # resources :admin, only: [:index]


end
