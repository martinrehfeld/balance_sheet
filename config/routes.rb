ActionController::Routing::Routes.draw do |map|
  map.resources :entries
  map.resources :entry_types
  map.resources :risk_classes
  map.resources :accounts
  map.root      :entries
end
