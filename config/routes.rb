Football::Application.routes.draw do
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


  devise_for :users, :admin
  namespace(:admin) do
    root :to => 'main#index'
    resources :comments
    resources :tournaments, :collection => {:grid_edit => :post} do
      resources :matches, :collection => {:grid_edit => :post}
      resources :teams, :collection => {:team_2_season => :get}
      resources :schedules
      resources :quick_match_results, :collection => {:update_all => :put}
      resources :steps
    end
    resources :steps, :member => {:teams => :get, :update_teams => :post}
    resources :schedules, :member => {:results => :get, :update_results => :post}, :collection => {:week => :get, :data => :get}
    resources :quick_match_results, :collection => {:update_all => :put}
    resources :teams, :member => {:footballers => :get, :update_footballers => :post}
    resources :matches, :member => {:results => :get, :update_results => :post, :update_referees => :post} do
      resources :match_events
    end
    resources :match_events
    resources :match_event_types, :collection => {:grid_edit => :post}
    resources :referees, :collection => {:grid_edit => :post}
    resources :footballers
    resources :permissions
    resources :venues
    match 'temp/:action/:id' => "temp"
  end

#  namespace(:univer) do
#    root :controller => 'main#index'
#    resources :tournaments, :has_many => :seasons
#  end

  resources :users
  resources :pages
  resources :schedules#, :collection => {:show_quick_results => :get}
  resource :profile, :collection => {:edit_photo => :get, :upload_photo => :post, :crop => :get, :destroy_photo => :delete, :make_crop => :post}
  resource :itleague_draw
  resources :footballers, :only => ["index", "show"]
  resources :quick_match_results, :only => ["show"]
  resources :venues, :only => ["show"]

  with_options :constraints => {:subdomain => /.+/} do
#  scope '/tournaments' do
    match '/feed' =>  "tournaments#feed"
    match '/' => "tournaments#index"
    match '/post' => 'post#show', :constraints =>  {:year=> /\d{4}/, :month=>/\d{1,2}/, :day=>/\d{1,2}/}
    resources :teams, :only => ["index", "show"]
    resources :tables, :only => ["index"]
    resources :bombardiers, :only => ["index"]
    resources :it_forecast, :only => ["index"]
    resources :pages, :only => ["show"]
    resources :seasons do
      resources :matches, :only => ["show", "index"]
    end

  end


  root :to => "blog#index"

  match ':year/:month/:day/:url' => "post#show", :constraints => {:year=> /\d{4}/, :month=>/\d{1,2}/, :day=>/\d{1,2}/}


  # Install the default routes as the lowest priority.
  match ':controller(/:action(/:id(.:format)))'
#  map.connect ':controller/:action/:id.:format'
  
end
