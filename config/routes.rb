require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'
      resources :articles, only: [:index]
    end
  end

  resources :novels

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end
  resources :articles,concerns: :paginatable

  root "articles#index"

  mount Sidekiq::Web => '/sikekiq'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
