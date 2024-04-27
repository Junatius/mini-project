Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'auth/login', to: 'auth#authenticate'

  resources :conversations, only: [:index, :show] do
    resources :chats, only: [:index, :create], controller: 'chats', path: 'messages'
  end

  resources :chats, only: [:create], path: 'messages'
end
