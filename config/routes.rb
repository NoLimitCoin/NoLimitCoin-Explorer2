Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/' => 'blocks#index'
  post '/search' => 'header#search'
  get '/api' => 'application#api'

  resources :blocks, only: [:index, :show] do
    collection do
      get 'block', action: :show
    end
  end

  resources :transactions, only: [:index, :show] do
    collection do
      get 'transaction', action: :show
    end
  end

  resources :addresses, only: [:index, :show] do
    collection do
      get 'address', action: :show
    end
  end

  resources :peers, only: [:index]
  resources :stats, only: [:index]

  # Custom routes
  get '/info' => 'application#api'
  get '/tx/:tx_hash' => 'transactions#show'
  get '/richlist' => 'addresses#index'
  get '/network' => 'peers#index'
  get '/movement' => 'blocks#index'
  get '/ext/getmoneysupply' => 'stats#getmoneysupply'
end
