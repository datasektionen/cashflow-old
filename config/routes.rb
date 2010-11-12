Cashflow::Application.routes.draw do  
  resources :product_types
  resources :business_units
  resources :purchases
  resources :debts
  
  resources :people
  # TODO: borde vi ha kanske nästla purchases och debts under people också?
  # det skulle kinda make sense för mobil-appen, om man inte vill rendera all den infon på people#show
  # Det skulle också vara vettigt för icke-admin/kassör/revisor, då de ändå bara ska kunna se sina egna inköp/skulder.
  # resources :people do
  #   resources :debts
  #   resources :purchases
  # end
  
  match 'login', :to => "person_sessions#new"
  match 'logout', :to => "person_sessions#destroy"
  root :to => "welcome#index"
end
