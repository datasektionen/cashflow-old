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

      primary.item :budgets, I18n.t('navigation.budgets'), budget_path(id: Time.now.year) do |secondary|
        BudgetPost.all_years.each do |year|
          secondary.item :"budget_year_#{year}", year, budget_path(id: year)
        end
      end

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
