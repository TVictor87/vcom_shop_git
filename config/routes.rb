Rails.application.routes.draw do
  namespace :admin do
    root 'home#index'

    devise_for :users, path: '', only: :session

    resources :products do
      resources :product_images
      # get :new_image
      # post :create_image
      # delete :delete_image
    end

    resources :categories

    resources :options_groups
    resources :options
    resources :sites
    resources :pages
  end

  devise_for :users
  root 'pages#index'

  resources :pages, olny: [:index, :show]

  get 'for_women', to: 'pages#categories', as: 'for_women', defaults: { url: 'for_women', column: 'url_ru' }
  get 'for_women/:category_url', to: 'pages#catalog', defaults: { url: 'for_women', column: 'url_ru' }

  # Dynamic Pages route
  get '*urls' => 'pages#show'
  # match '*path', to: 'pages#show', via: [:get, :post]
end
