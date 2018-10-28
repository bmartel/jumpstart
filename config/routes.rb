require 'sidekiq/web'

Rails.application.routes.draw do

  root to: 'home#index'

  ActiveAdmin.routes(self)

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  authenticate :user, lambda{ |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :announcements, only: [:index]
  resources :notifications, only: [:index]

  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'

end
