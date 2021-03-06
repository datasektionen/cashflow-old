Cashflow::Application.routes.draw do
  localized do
    resources :budget_posts

    devise_for :users,
               class_name: "Person",
               controllers: { omniauth_callbacks: "people/omniauth_callbacks" }
    devise_scope :user do
      get "sign_in",
          to: "people/omniauth_callbacks#new",
          as: :new_session
      delete "sign_out",
             to: "people/omniauth_callbacks#destroy",
             as: :destroy_user_session
      root to: "dashboard#index"
    end

    resources :product_types
    resources :budget, except: [:destroy] do
      resources :budget_rows, as: "rows", only: [:index, :show, :edit, :update]
    end
    resources :budget_posts
    resources :business_units
    resources :purchases do
      collection do
        get :confirmed
        put :pay_multiple
      end
      member do
        put :confirm
        put :pay
        put :keep
        put :cancel
      end
    end

    resources :people, except: [:destroy] do
      collection do
        get :search
      end
    end

    root to: "dashboard#index"
  end
end
