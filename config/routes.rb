# -*- encoding : utf-8 -*-
require "#{Rails.root}/lib/subdomain.rb"
FootballKharkov::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users
  devise_for :admins, :controllers => {:sessions => "admin/session"}

  #as :admin do
  #  get "/admins/sign_in" => "admin/session#new", :as => :new_admin_session

    #get 'signin' => 'devise/sessions#new', :as => :new_user_session
    #post '/admins/sign_in' => 'admin/session#create', :as => :admin_session
    #delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session

  #end

  namespace(:admin) do
    root :to => 'main#index'
    resources :comments
    resources :tournaments do
      resources :matches do
        post :grid_edit
      end
      resources :teams do
        get :team_2_season
      end
      resources :schedules
      resources :quick_match_results do
        put :update_all
      end
      resources :steps
      post :grid_edit
    end
    resources :steps do
      member do
        get :teams
        post :update_teams
      end
    end

    resources :schedules do
      member do
        get :results
        post :update_results
      end
      get :week
      get :data
    end

    resources :quick_match_results do
      put :update_all
    end

    resources :teams do
      member do
        get :footballers
        post :update_footballers
      end
    end
    resources :matches do
      resources :match_events
      member do
        get :results
        post :update_results, :update_referees
      end
    end
    resources :match_events
    resources :match_event_types do
      post :grid_edit
    end
    resources :referees do
      post :grid_edit
    end
    resources :footballers
    resources :permissions
    resources :venues
    resources :user_requests do
      get :merge
    end
    match 'temp(/:action(/:id))' => "temp"
    match 'import(/:action(/:id))' => "import"
  end

  match "/:hash/:id" => 'users#show', :constraints => {:hash => '!!'}
  match 'users/feed/:id' => 'users#feed'

  #  match "/!!/:id" => 'users#show', :constraints => {:controller => '#!'}
  #  match 'users/feed/:id' => 'users#feed'


  resources :users do
      get :feed, :format => "xml"
  end
  resources :pages
  resources :schedules
  resources :statuses
  resource :profile do
    collection do
      get :edit_photo, :crop
      post :upload_photo, :make_crop
      delete :destroy_photo
    end
  end

  match '/itleague_draw' => "itleague_draw#index"
  resources :footballers, :only => ["index", "show"] do
    get :edit_photo, :crop, :its_me
    post :upload_photo, :make_crop
    delete :destroy_photo
  end
  resources :quick_match_results, :only => ["show"]
  resources :venues, :only => ["show"]


#  with_options :constraints => {:subdomain => /.+/} do
#  constraints(Subdomain) do
    match '/feed' =>  "tournaments#feed", constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }, :format => "xml"
    match '/' => "tournaments#index", :as => "tournament", constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
    #match ':year/:month/:day/:url' => "post#show", :constraints => {:year=> /\d{4}/, :month=>/\d{1,2}/, :day=>/\d{1,2}/}, :as => "post", constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
    match ':year/:month/:day/:url' => "post#show", :as => "post", constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }, :year=> /\d{4}/, :month=>/\d{1,2}/, :day=>/\d{1,2}/
  #end
  
  resources :football_player_appointment, :only => ["update"]
  resources :team_appointment, :only => ["show"]
  resources :teams, :only => ["index", "show"]
  resources :tables, :only => ["index"]
  resources :bombardiers, :only => ["index"]
  resources :disqualifications, :only => ["index"]
  resources :it_forecast, :only => ["index"]
  resources :pages, :only => ["show"]
  resources :seasons do
    resources :matches, :only => ["show", "index"]
  end

  root :to => "blog#index"

  match '/auth/:provider/:action' => 'oauth_provider', :as => "oauth_provider"
  match '/auth/failure' => 'oauth_provider#failure'

  match ':year/:month/:day/:url' => "post#show", :constraints => {:year=> /\d{4}/, :month=>/\d{1,2}/, :day=>/\d{1,2}/}

  match ':controller(/:action(/:id(.:format)))'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
