class Ability
  include CanCan::Ability

  def initialize(user)

    if user.is? :admin
      # Admin can do everything
      can :manage, :all
    elsif user.is? :treasurer
      # Treasurers can create users in order to put them in debt
      can :create, Person
      
      can :manage, [ProductType, BusinessUnit, Purchase, PurchaseItem, Debt]
    elsif user.is? :accountant
      # Accountants should be able to read everything
      can :read, :all
    else
      # Ordinary users can only edit themselves
      can :manage, Person, :id => user.id
      cannot :create, Person
      cannot :confirm, Purchase
    end
    can [:read, :create, :edit, :update, :show], Purchase, :person_id => user.id
    can :read, Debt, :person_id => user.id
  end
end
