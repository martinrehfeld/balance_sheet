ActionController::Routing::Routes.draw do |map|
  map.resources :account_classes

  map.resources :entries
  map.resources :entry_types
  map.resources :risk_classes
  map.resources :accounts
  map.root      :controller => 'balance_sheet'
  map.connect   'balances_by_risk_class_chart.:format', :controller => 'balance_sheet'
  map.connect   'future_payments_chart.:format', :controller => 'balance_sheet', :action => 'future_payments'
end
