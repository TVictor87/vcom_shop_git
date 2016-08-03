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
    resources :option_groups
    resources :options
    resources :pages
    resources :warehouses, except: :show
    resources :warehouse_products, only: [:create, :update,:destroy]
    resources :sites
  end

  post 'catalog', to: 'catalog#catalog_json'

  devise_for :users
  root 'pages#index'

  resources :pages, olny: [:index, :show]

  get 'zhenshchinam', to: 'catalog#categories', as: 'women_ru', defaults: { url: 'zhenshchinam', column: 'url_ru' }
  get 'zhenshchinam/:category_url', to: 'catalog#catalog', defaults: { url: 'zhenshchinam', column: 'url_ru' }
  get 'zhenshchinam/:category_url/:product_id', to: 'products#show', defaults: { url: 'zhenshchinam', column: 'url_ru' }
  get 'women', to: 'catalog#categories', as: 'women_en', defaults: { url: 'women', column: 'url_en' }
  get 'women/:category_url', to: 'catalog#catalog', defaults: { url: 'women', column: 'url_en' }
  get 'women/:category_url/:product_id', to: 'products#show', defaults: { url: 'women', column: 'url_en' }
  get 'zhinkam', to: 'catalog#categories', as: 'women_uk', defaults: { url: 'zhinkam', column: 'url_uk' }
  get 'zhinkam/:category_url', to: 'catalog#catalog', defaults: { url: 'zhinkam', column: 'url_uk' }
  get 'zhinkam/:category_url/:product_id', to: 'products#show', defaults: { url: 'zhinkam', column: 'url_uk' }

  get 'muzhchinam', to: 'catalog#categories', as: 'men_ru', defaults: { url: 'muzhchinam', column: 'url_ru' }
  get 'muzhchinam/:category_url', to: 'catalog#catalog', defaults: { url: 'muzhchinam', column: 'url_ru' }
  get 'muzhchinam/:category_url/:product_id', to: 'products#show', defaults: { url: 'muzhchinam', column: 'url_ru' }
  get 'men', to: 'catalog#categories', as: 'men_en', defaults: { url: 'men', column: 'url_en' }
  get 'men/:category_url', to: 'catalog#catalog', defaults: { url: 'men', column: 'url_en' }
  get 'men/:category_url/:product_id', to: 'products#show', defaults: { url: 'men', column: 'url_en' }
  get 'cholovikam', to: 'catalog#categories', as: 'men_uk', defaults: { url: 'cholovikam', column: 'url_uk' }
  get 'cholovikam/:category_url', to: 'catalog#catalog', defaults: { url: 'cholovikam', column: 'url_uk' }
  get 'cholovikam/:category_url/:product_id', to: 'products#show', defaults: { url: 'cholovikam', column: 'url_uk' }

  get 'detyam', to: 'catalog#categories', as: 'child_ru', defaults: { url: 'detyam', column: 'url_ru' }
  get 'detyam/:category_url', to: 'catalog#catalog', defaults: { url: 'detyam', column: 'url_ru' }
  get 'detyam/:category_url/:product_id', to: 'products#show', defaults: { url: 'detyam', column: 'url_ru' }
  get 'child', to: 'catalog#categories', as: 'child_en', defaults: { url: 'child', column: 'url_en' }
  get 'child/:category_url', to: 'catalog#catalog', defaults: { url: 'child', column: 'url_en' }
  get 'child/:category_url/:product_id', to: 'products#show', defaults: { url: 'child', column: 'url_en' }
  get 'dityam', to: 'catalog#categories', as: 'child_uk', defaults: { url: 'dityam', column: 'url_uk' }
  get 'dityam/:category_url', to: 'catalog#catalog', defaults: { url: 'dityam', column: 'url_uk' }
  get 'dityam/:category_url/:product_id', to: 'products#show', defaults: { url: 'dityam', column: 'url_uk' }

  # Dynamic Pages route
  get '*urls' => 'pages#show'
  # match '*path', to: 'pages#show', via: [:get, :post]
end
