Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
#heroku welcome page
root 'welcome#index'

get '/merchants/:merchant_id/dashboard', to: 'merchants#dashboard'
# get '/merchants/:merchant_id/items', to: 'merchant_items#index'
get '/merchants/:merchant_id/invoices', to: 'merchant_invoices#index'

  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index, :show]
    resources :items, only: [:index, :show, :edit, :update]
    # resources :invoices, only: [:index, :show]
  end
end
