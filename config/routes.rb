ActionController::Routing::Routes.draw do |map|
  map.resources :repositories
  map.root :controller => "repositories"
end
