Rails.application.routes.draw do
  resources :article_slugs
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :edits
      resources :moderators
      resources :games
      resources :users
      resources :sessions
      resources :headings
      resources :articles
      resources :slugs
    end
  end
end
