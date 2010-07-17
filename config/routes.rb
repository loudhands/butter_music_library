ActionController::Routing::Routes.draw do |map|
  map.resources :tracks, :collection => { :edit_multiple => :post, :update_multiple => :put }
  
  map.formatted_tracks 'tracks.:format', :controller => 'tracks', :action => 'index'
  
  map.root :controller => 'tracks'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
