Cashflow::Application.routes.draw do  
  resources :budget_posts

  devise_for :people, :controllers => {:omniauth_callbacks => "people/omniauth_callbacks"} do
    get "sign_in", :to => "people/omniauth_callbacks#new", :as => :new_person_session
    get "sign_out", :to => "people/omniauth_callbacks#destroy", :as => :destroy_person_session
  end

  localized(['sv']) do
    resources :product_types
    resources :budget_posts
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

    resources :people, :except => [:destroy] do
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
