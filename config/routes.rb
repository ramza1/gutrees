#require "sidekiq/web"

Gutrees::Application.routes.draw do
  get "comments/create"

  get "users/show"

  resources :comments

  resources :categories

  resources :broadcasts do
    member do
      get :bookmark
      get :remove_bookmark
      get :toggle_flag
    end
    resources :comments
  end

  resources :branches  do
    member do
      get :sub_branches
      get :admins
      get :privacy_settings
      get :toggle_privacy
    end
    resources :memberships do
      collection do
        get  :batch
        post :batch
      end
    end
    resources :broadcasts
  end

  devise_for :users, path_prefix: "account", path_names: {sign_in: "login", sign_out: "logout" }, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  resources :memberships do
    collection do
      get  :batch
      post :batch
    end
  end
  resources :users do
     member do
      get :branch_ins
      get :my_branches
      get :bookmarked_items
     end
  end

  match '/get_started', :to => 'home#get_started',:as=>"get_started"
  match '/trending', :to => 'home#trending',:as=>"trending"
  match '/about_us', :to => 'home#about_us',:as=> :about_us
  match '/terms_of_use', :to => 'home#terms',:as=> :terms
  match '/policy', :to => 'home#policy',:as=> :policy
  match '/faq', :to => 'home#faq',:as=> :faq

  #constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.is_admin? }
  #constraints constraint do
    #mount Sidekiq::Web => '/sidekiq'
  #end

  match "/search" => "branches#search", as: :search_box
  match "/:id" => "branches#show", :as => :branch_home
  root :to => "home#popular"
end
