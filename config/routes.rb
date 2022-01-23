Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  require 'sidekiq/web'
  
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :applications, param: :token, only: [:index, :show, :create, :update] do
        resources :chats, param: :number, only: [:index, :show, :create, :update] do
          resources :messages, param: :number, only: [:index, :show, :create, :update] do
          end
        end
      end
      get 'messages/search'
    end
  end
end
