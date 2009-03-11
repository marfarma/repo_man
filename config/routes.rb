ActionController::Routing::Routes.draw do |map|
  map.resources :repositories, :only => [:index, :new, :create]
  map.root :controller => "repositories"
end
