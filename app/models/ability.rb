class Ability
  include CanCan::Ability

  def initialize(user)

    if user.is? :admin
      # Admin can do everything
      can :manage, :all
    elsif user.is? :treasurer
      # Treasurers can create users in order to put them in debt
      can :create, Person
      
      can :manage, ProductType
      can :manage, BusinessUnit
      can :manage, Purchase
      can :manage, Debt
    elsif user.is? :accountant
      # Accountants should be able to read everything
      can :read, :all
    else
      # Ordinary users can only edit themselves
      can :manage, Person, :id => user.id
      cannot :create, Person
      can :read, Debt, :person_id => user.id
    end
    can :manage, Purchase, :person_id => user.id
  end
end
