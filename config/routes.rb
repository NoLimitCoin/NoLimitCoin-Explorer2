Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/' => 'blocks#index'
  post '/search' => 'header#search'

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
end
