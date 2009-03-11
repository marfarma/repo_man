ActionController::Routing::Routes.draw do |map|
  map.resources :repositories, :only => [:index, :show, :new, :create]
  map.root :controller => "repositories"
end
