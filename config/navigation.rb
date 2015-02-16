# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  localize = ->(field) { I18n.t("navigation.#{field}") }
  navigation.items do |primary|
    if user_signed_in?
      primary.item :purchases, localize["purchases"], purchases_path do |sub|
        sub.item :all_purchases, localize["all_purchases"], purchases_path
        if can?(:manage, Purchase)
          sub.item :confirmed_purchases,
                   localize["confirmed_purchases"],
                   confirmed_purchases_path
        end
        sub.item :new_purchase, localize["new_purchase"], new_purchase_path
      end

      primary.item :budgets, localize["budgets"],
                   budget_path(id: Time.now.year) do |secondary|
        BudgetPost.all_years.each do |year|
          secondary.item :"budget_year_#{year}", year, budget_path(id: year)
        end
      end

      primary.item :administration, "Administration", "" do |secondary|
        if current_user.is?(:admin)
          secondary.item(:people, localize["people"], people_path)
        end
        if can?(:manage, BusinessUnit)
          secondary.item :business_units,
                         localize["business_units"],
                         business_units_path
        end
        if can?(:manage, ProductType)
          secondary.item :product_types,
                         localize["product_types"],
                         product_types_path
        end
        if can?(:manage, BudgetPost)
          secondary.item :budget_posts,
                         localize["budget_posts"],
                         budget_posts_path
        end
      end

      primary.item :user,
                   current_user.name,
                   person_path(current_user) do |secondary|
        secondary.item :my_page, localize["my_page"], person_path(current_user)
        secondary.item :logout, "Logga ut",
                       destroy_user_session_path, method: :delete
      end
    else
      primary.item :login, I18n.t("navigation.sign_in"), "/users/auth/cas"
      if Cashflow::Application.settings["enable_developer_login_strategy"]
        primary.item :dev_login,
                     I18n.t("navigation.dev_sign_in"),
                     "/users/auth/developer"
      end
    end
  end
end
