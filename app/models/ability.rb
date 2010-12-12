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
    elsif user.is? :accountant
      # Accountants should be able to read everything
      can :read, :all
    else
      # Ordinary users can only edit themselves
      can :manage, Person, :id => user.id
    end
  end
end
