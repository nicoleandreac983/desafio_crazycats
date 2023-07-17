Rails.application.routes.draw do
  resources :comments
  get 'home/index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :posts do
    member do
      put 'like', to: 'posts#like'
      put 'dislike', to: 'posts#dislike'
      put 'unlike', to: 'posts#unlike'
      put 'undislike', to: 'posts#undislike'
    end
  end

  # resources :posts, except: [:index]
  root "home#index"
  resources :posts
end
