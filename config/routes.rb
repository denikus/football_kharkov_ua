ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  # See how all your routes lay out with "rake routes"

#  map.cms ":cmspage",
#          :controller => "page",
#          :action => "show",
#          :requirements => { :cmspage => /[a-zA-Z0-9_]+(\.htm)/,}

#  devise_for :users


  map.root :controller => "blog"
  
  map.devise_for :admin
  map.namespace(:admin) do |admin|
    admin.root :controller => 'main'
    admin.resources :comments
    admin.resources :tournaments, :has_many => :seasons
    admin.resources :seasons, :has_many => :stages
    admin.resources :stages, :has_many => :leagues
    admin.resources :leagues, :has_many => [:teams, :tours]
    admin.resources :teams, :has_many => [:leagues, :footballers]
    admin.resources :tours, :has_many => :matches
    admin.resources :matches do |m|
      m.resources :match_events, :as => :events
      m.resources :competitors
      m.resource :stats
    end
    admin.resources :referees
    admin.resources :footballers
    admin.resources :permissions
  end
  
  map.devise_for :users
  map.resources :users do |user|
    user.resource :profile do |p|
      p.resource :avatar, :as => :photo, :controller => :profile_avatars
    end
  end



  map.post ':year/:month/:day/:url',
    :controller=>'post',
    :action=>'show',
    :requirements=> {:year=> /\d{4}/, :month=>/\d{1,2}/, :day=>/\d{1,2}/}

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  #user area
  #map.username "/:username/:action",
  #  :controller => 'profile'
end
