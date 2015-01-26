class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:edit, :update, :show], Person, id: user.id
      can [:read, :create, :edit, :update, :show], Purchase, person_id: user.id
      can :read, ProductType

      send("setup_#{user.role}", user) unless user.role.blank?
    end
  end

  private

  def setup_admin(user)
    # Admin can do everything
    can :manage, :all
  end

  def setup_treasurer(user)
    can [:index, :new, :create], Person
    can [:edit, :update], Person, id: user.id
    can :manage, [Purchase, PurchaseItem, BusinessUnit, ProductType, BudgetPost]
    can :edit, :purchase_owner
    can :manage, :budget
  end

  def setup_bookkeeper(user)
    can :index, [Person, Purchase, BusinessUnit, ProductType, BudgetPost]
    can :bookkeep, [Purchase]
    can :pay, [Purchase]
  end

  def setup_accountant(user)
    # Accountants should be able to read everything
    can :read, :all
    can :manage, :people, id: user.id
    can :index, :people
  end
end
