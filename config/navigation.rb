# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
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

    primary.item :budgets, I18n.t('navigation.budgets'), budget_path(:id => Time.now.year) do |secondary|
      BudgetPost.all_years.each { |year|
        secondary.item :"budget_year_#{year}", year, budget_path(id: year)
      }
    end

    if current_user.is?(:admin)
      primary.item(:people, I18n.t('navigation.people'), people_path)
    end

    if can?(:manage, BusinessUnit)
      primary.item :business_units, I18n.t('navigation.business_units'), business_units_path do |sub|
        sub.item :all_business_units, I18n.t('navigation.all_business_units'), business_units_path
        sub.item :new_business_unit, I18n.t('navigation.new_business_unit'), new_business_unit_path
      end
    end

    if can?(:manage, ProductType)
      primary.item :product_types, I18n.t('navigation.product_types'), product_types_path do |sub|
        sub.item :all_product_types, I18n.t('navigation.all_product_types'), product_types_path
        sub.item :new_product_type, I18n.t('navigation.new_product_type'), new_product_type_path
      end
    end

    if can?(:manage, BudgetPost)
      primary.item :budget_posts, I18n.t('navigation.budget_posts'), budget_posts_path do |sub|
        sub.item :all_budget_posts, I18n.t('navigation.all_budget_posts'), budget_posts_path
        sub.item :new_budget_post, I18n.t('navigation.new_budget_post'), new_budget_post_path
      end
    end

    if user_signed_in?
      primary.item :user, current_user.name, person_path(current_user) do |secondary|
        secondary.item :my_page, I18n.t('navigation.my_page'), person_path(current_user)
        secondary.item :logout, "Logga ut", destroy_user_session_path
      end
    end
  end
end
