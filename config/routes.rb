ActionController::Routing::Routes.draw do |map|
  map.resources :tracks
  
  map.root :controller => 'tracks'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
