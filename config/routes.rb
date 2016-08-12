Rails.application.routes.draw do

  resources :activities
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'pages#index'
  get "privacy_policy" => "pages#privacy" # for web site
  get "terms_condition" => "pages#terms" # for web site
  get "template" => "pages#videotemp"# for web site
  get "contact" => "pages#contact" # for web site
  get "/privacy" => "staticpage#privacy_policy" #for api
  get "/tc" => "staticpage#terms_condition" # for api
  mount_opro_oauth

  devise_scope :user do 
    get "/forgot" => "devise/passwords#new"
  end 

  match '/terms' => 'pages#terms', via: :get
  match '/privacy' => 'pages#privacy', via: :get

  resources :categories
  resources :likes
  resources :comments
  devise_for :users
  # devise_for :users, :controllers => { :passwords => "Passwords" }
  resources :videos

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get "/" => "pages#api", defaults: {format: 'html'}
      
      resources :users do
        member do  
          get :followers
          get :following 
          get :feed
          get :liked
          get :notifications
          get :report
          get :videos
          get :block
        end
         collection do
           post :token_auth
           get :blocklist
        end
        resources :follow, shallow: false, only: [:index, :update, :destroy]
      end
      
      resources :videos do 
        member do 
          get :report
        end
      end
      
      resources :categories do
        member do 
          get :show_like
        end
      end
      resources :comments

      match '/search' => 'search#index', via: :get
      match '/videos/:video_id/comments' => 'videos#comments', via: :get

      resources :likes
      match "/likes/:video_id" => "likes#create", via: :post
    end
  end
end
 