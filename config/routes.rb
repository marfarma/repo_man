ActionController::Routing::Routes.draw do |map|
  map.resources :repositories, :except => [:edit, :update]
  map.root :controller => "repositories"
end
