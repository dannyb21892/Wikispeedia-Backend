Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :home_edits
      resources :homes
      resources :followers
      resources :article_slugs
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
