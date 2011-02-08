Cashflow::Application.routes.draw do  
  localized(['sv']) do
    resources :product_types
    resources :business_units
    resources :purchases do
      member do
        put :confirm
        put :pay
        put :keep
        put :cancel
      end
    end
    resources :debts do
      member do
        put :pay
        put :keep
        put :cancel
      end
    end

    resources :people do
      collection do
        get :search
      end
    end

    # TODO: borde vi ha kanske nästla purchases och debts under people också?
    # Det skulle kinda make sense för mobil-appen, om man inte vill rendera all den infon på people#show
    # Det skulle också vara vettigt för icke-admin/kassör/revisor, då de ändå bara ska kunna se sina egna inköp/skulder.
    # Det skulle ju även göra routes lite snyggare... /person/:person_id/purchases/new liksom...
    # resources :people do
    #   resources :debts
    #   resources :purchases
    # end

    match 'login', :to => "person_sessions#new"
    match 'logout', :to => "person_sessions#destroy"
    root :to => "welcome#index"
  end
end
