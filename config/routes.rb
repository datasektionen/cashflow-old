Cashflow::Application.routes.draw do  
  devise_for :people

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
    resources :debts, :except => [:edit, :update, :destroy] do
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
    # En annan tanke är att lägga sånt under en /my controller,
    # så att man loggar in och hamnar på /mina/sidor (eller något lämpligare), som är en overview,
    # och så kan man gå till /mina/inkop, /mina/skulder eller whatever
    # 

    root :to => "welcome#index"
  end
end
