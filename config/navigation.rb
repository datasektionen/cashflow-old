# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    if user_signed_in?
      primary.item :purchases, I18n.t('navigation.purchases'), purchases_path do |sub|
        sub.item :all_purchases, I18n.t('navigation.all_purchases'), purchases_path
        if can?(:manage, Purchase)
          sub.item :confirmed_purchases, I18n.t('navigation.confirmed_purchases'), confirmed_purchases_path
        end
        sub.item :new_purchase, I18n.t('navigation.new_purchase'), new_purchase_path
      end

      primary.item :debts, I18n.t('navigation.debts'), debts_path do |sub|
        sub.item :all_debts, I18n.t('navigation.all_debts'), debts_path
        if can?(:create, Debt)
          sub.item :new_debt, I18n.t('navigation.new_debt'), new_debt_path
        end
      end

      primary.item :budgets, I18n.t('navigation.budgets'), budget_path(id: Time.now.year) do |secondary|
        BudgetPost.all_years.each do |year|
          secondary.item :"budget_year_#{year}", year, budget_path(id: year)
        end
      end

      # sub.item :new_business_unit, I18n.t('navigation.new_business_unit'), new_business_unit_path
      # sub.item :new_product_type, I18n.t('navigation.new_product_type'), new_product_type_path
      # sub.item :new_budget_post, I18n.t('navigation.new_budget_post'), new_budget_post_path

      primary.item :administration, 'Administration', '' do |secondary|
        if current_user.is?(:admin)
          secondary.item(:people, I18n.t('navigation.people'), people_path)
        end
        if can?(:manage, BusinessUnit)
          secondary.item :business_units, I18n.t('navigation.business_units'), business_units_path
        end
        if can?(:manage, ProductType)
          secondary.item :product_types, I18n.t('navigation.product_types'), product_types_path
        end
        if can?(:manage, BudgetPost)
          secondary.item :budget_posts, I18n.t('navigation.budget_posts'), budget_posts_path
        end
      end

      primary.item :user, current_user.name, person_path(current_user) do |secondary|
        secondary.item :my_page, I18n.t('navigation.my_page'), person_path(current_user)
        secondary.item :logout, 'Logga ut', destroy_user_session_path
      end
    else
      primary.item :login, I18n.t('navigation.sign_in'), '/users/auth/cas'
    end
  end
end
