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
    resources :currencies
    resources :options_groups
    resources :options
    resources :sites
    resources :pages
  end

  post 'catalog', to: 'pages#catalog_json'

  devise_for :users
  root 'pages#index'

  resources :pages, olny: [:index, :show]

  get 'zhenshchinam', to: 'pages#categories', as: 'women_ru', defaults: { url: 'zhenshchinam', column: 'url_ru' }
  get 'zhenshchinam/:category_url', to: 'pages#catalog', defaults: { url: 'zhenshchinam', column: 'url_ru' }
  get 'women', to: 'pages#categories', as: 'women_en', defaults: { url: 'women', column: 'url_en' }
  get 'women/:category_url', to: 'pages#catalog', defaults: { url: 'women', column: 'url_en' }
  get 'zhinkam', to: 'pages#categories', as: 'women_uk', defaults: { url: 'zhinkam', column: 'url_en' }
  get 'zhinkam/:category_url', to: 'pages#catalog', defaults: { url: 'zhinkam', column: 'url_en' }

  get 'muzhchinam', to: 'pages#categories', as: 'men_ru', defaults: { url: 'muzhchinam', column: 'url_ru' }
  get 'muzhchinam/:category_url', to: 'pages#catalog', defaults: { url: 'muzhchinam', column: 'url_ru' }
  get 'men', to: 'pages#categories', as: 'men_en', defaults: { url: 'men', column: 'url_ru' }
  get 'men/:category_url', to: 'pages#catalog', defaults: { url: 'men', column: 'url_ru' }
  get 'cholovikam', to: 'pages#categories', as: 'men_uk', defaults: { url: 'cholovikam', column: 'url_ru' }
  get 'cholovikam/:category_url', to: 'pages#catalog', defaults: { url: 'cholovikam', column: 'url_ru' }

  get 'detyam', to: 'pages#categories', as: 'child_ru', defaults: { url: 'detyam', column: 'url_ru' }
  get 'detyam/:category_url', to: 'pages#catalog', defaults: { url: 'detyam', column: 'url_ru' }
  get 'child', to: 'pages#categories', as: 'child_en', defaults: { url: 'child', column: 'url_ru' }
  get 'child/:category_url', to: 'pages#catalog', defaults: { url: 'child', column: 'url_ru' }
  get 'dityam', to: 'pages#categories', as: 'child_uk', defaults: { url: 'dityam', column: 'url_ru' }
  get 'dityam/:category_url', to: 'pages#catalog', defaults: { url: 'dityam', column: 'url_ru' }

  # Dynamic Pages route
  get '*urls' => 'pages#show'
  # match '*path', to: 'pages#show', via: [:get, :post]
end
