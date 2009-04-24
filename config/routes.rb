ActionController::Routing::Routes.draw do |map|
  map.resources :repositories
  map.api "api", :controller => "api", :action => "index"
  map.root :controller => "repositories"
end
