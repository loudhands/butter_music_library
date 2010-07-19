ActionController::Routing::Routes.draw do |map|
  map.resources :users do |users|
    users.resource :password, :controller => 'clearance/passwords', :only => [:create, :edit, :update]
  end
  
  map.resource  :session, :controller => 'sessions', :only => [:new, :create, :destroy]
  
  map.sign_in '/sign_in', :controller => 'sessions', :action => 'new'
  map.sign_out '/sign_out', :controller => 'sessions', :action => 'destroy'
  
  map.resources :tracks, :collection => { :edit_multiple => :post, :update_multiple => :put, :delete_multiple => :delete }
  
  map.formatted_tracks 'tracks.:format', :controller => 'tracks', :action => 'index'
  
  map.root :controller => 'tracks'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
