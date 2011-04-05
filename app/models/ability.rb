class Ability
  include CanCan::Ability

  def initialize(user)
    
    if user
      if user.is? :admin
        # Admin can do everything
        can :manage, :all
        can :access, :all
      elsif user.is? :treasurer
        can :access, [:product_types, :business_units, :purchases, :debts]
        can [:index, :new, :create], :people
        can [:edit, :update], :people, :id => user.id
      elsif user.is? :accountant
        # Accountants should be able to read everything
        can :read, :all
        can :manage, :people, :id => user.id
        can :index, :people
      else
        # Ordinary users can only edit themselves
        can :manage, :people, :id => user.id
        cannot :create, :people
        cannot :confirm, :purchase
        cannot :cancel, :purchases
        cannot :index, :people
        cannot :cancel, :debts
      end
      can [:read, :create, :edit, :update, :show], :purchases, :person_id => user.id
      can :read, :debts, :person_id => user.id
    end
  end
end

