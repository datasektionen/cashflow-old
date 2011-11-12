class Ability
  include CanCan::Ability

  def initialize(user)
    
    if user
      can [:edit, :update, :show], Person, :id => user.id
      can [:read, :create, :edit, :update, :show], Purchase, :person_id => user.id
      can :read, Debt, :person_id => user.id
      can :read, ProductType
      if user.is? :admin
        # Admin can do everything
        can :manage, :all
        #can :access, :all
      elsif user.is? :treasurer
        can :manage, [:product_types, :business_units, :purchases, :debts, :budget_posts]
        can [:index, :new, :create], Person
        can [:edit, :update], Person, :id => user.id
		  can :edit, :purchase_owner
      elsif user.is? :accountant
        # Accountants should be able to read everything
        can :read, :all
        can :manage, :people, :id => user.id
        can :index, :people
      else
        # Ordinary users can only edit themselves
        cannot :manage, :people
        can :manage, :people, :id => user.id
        cannot :confirm, :purchase
        cannot :cancel, :purchases
        cannot :cancel, :debts
        cannot :index, :people
      end
    else
      can :read, :welcome
    end
  end
end

