require "spec_helper"
require 'cancan'
require 'cancan/matchers'

describe Ability do
  describe "admin" do
    before(:each) do
      @user = Factory(:admin)
      @ability = Ability.new(@user)
    end
    it "should be able to manage people" do
      @ability.should be_able_to(:manage, Person)
    end

    it "should be able to index people" do
      @ability.should be_able_to(:index, Person)
    end

    it "should be able to manage purchases" do
      @ability.should be_able_to(:manage, Purchase.new)
      @ability.should be_able_to(:manage, PurchaseItem.new)
    end

    it "should be able to manage debts" do
      @ability.should be_able_to(:manage, Debt.new)
    end

    it "should be able to manage business units" do
      @ability.should be_able_to(:manage, BusinessUnit.new)
    end

    it "should be able to manage product types" do
      @ability.should be_able_to(:manage, ProductType.new)
    end
  end

  describe "treasurer" do
    before(:each) do
      @user = Factory(:treasurer)
      @ability = Ability.new(@user)
    end

    %w[create index].each do |action|
      it "should be able to #{action} people" do
        @ability.should be_able_to(action.to_sym, Person)
      end
    end

    it "should not be able to manage people" do
      @ability.should_not be_able_to(:manage, :people)
    end

    %w[product_types business_units purchases debts budget_posts].each do |model|
      let(:class_name) { model.gsub(/\s/,'_').singularize.camelize.constantize }

      it "should be able to manage model" do
        @ability.should be_able_to(:manage, class_name)
      end

      it "should be able to index model" do
        @ability.should be_able_to(:index, class_name)
      end
    end

    it "should be able to edit itself" do
      @ability.should be_able_to(:edit, @user)
      @ability.should be_able_to(:update, @user)
    end

    it "should be able to manage purchases" do
      @ability.should be_able_to(:manage, Purchase.new)
      @ability.should be_able_to(:manage, PurchaseItem.new)
    end

    it "should be able to manage debts" do
      @ability.should be_able_to(:manage, Debt.new)
    end
  end

  describe "bookkeeper" do
    before(:each) do
      @user = Factory(:bookkeeper)
      @ability = Ability.new(@user)
    end

    %w[index].each do |action|
      it "should be able to #{action} people" do
        @ability.should be_able_to(action.to_sym, Person)
      end
    end

    it "should not be able to manage people" do
      @ability.should_not be_able_to(:manage, :people)
    end

    %w[product_types business_units purchases debts budget_posts].each do |model|
      let(:class_name) { model.gsub(/\s/,'_').singularize.camelize.constantize }

      it "should not be able to manage model" do
        @ability.should_not be_able_to(:manage, class_name)
      end

      it "should be able to index model" do
        @ability.should be_able_to(:index, class_name)
      end
    end

    it "should be able to edit itself" do
      @ability.should be_able_to(:edit, @user)
      @ability.should be_able_to(:update, @user)
    end

    it "should not be able to manage purchases" do
      @ability.should_not be_able_to(:manage, Purchase.new)
      @ability.should_not be_able_to(:manage, PurchaseItem.new)
    end

    it "should be not able to manage debts" do
      @ability.should_not be_able_to(:manage, Debt.new)
    end

    it "should be able to bookkeep purchases" do
      @ability.should be_able_to(:bookkeep, Purchase.new)
    end

    it "should be able to mark purchases as paid" do
      @ability.should be_able_to(:pay, Purchase.new)
    end
  end

  describe "ordinary user" do
    before(:each) do
      @user = Factory(:person)
      @ability = Ability.new(@user)
    end

    it "should not be able to edit product types" do
      @ability.should_not be_able_to(:manage, ProductType.new)
    end

    it "should not be able to edit business units" do
      @ability.should_not be_able_to(:manage, BusinessUnit.new)
    end

    it "should not be able to edit an arbitrary user" do
      @ability.should_not be_able_to(:manage, Person.new)
    end

    it "should not be able to create a new person" do
      @ability.should_not be_able_to(:create, Person)
    end

    it "should be able to edit its own purchases" do
      @ability.should be_able_to(:edit, @user.purchases.new)
    end

    it "should not be able to confirm its own purchases" do
      @ability.should_not be_able_to(:confirm, @user.purchases.new)
    end

    it "should not be able to pay/bookkeep its own purchases" do
      @ability.should_not be_able_to(:pay, @user.purchases.new(:workflow_state => "confirmed"))
      @ability.should_not be_able_to(:keep, @user.purchases.new(:workflow_state => "confirmed"))
    end

    it "should be able to read its own debts" do
      @ability.should be_able_to(:read, @user.debts.new)
    end

    it "sholud be able to view itself" do
      @ability.should be_able_to(:show, @user)
    end

    it "sholud be able to edit itself" do
      @ability.should be_able_to(:edit, @user)
      @ability.should be_able_to(:update, @user)
    end

    it "should not be able to edit its own debts" do
      @ability.should_not be_able_to(:edit, @user.debts.new)
    end

    it "should not be able to index people" do
      @ability.should_not be_able_to(:index, Person)
    end
  end

  describe "accountant" do
    before(:each) do
      @user = Factory(:accountant)
      @ability = Ability.new(@user)
    end

    it "should be able to index people" do
      @ability.should be_able_to(:index, Person)
    end

    it "should be able to read product types" do
      @ability.should be_able_to(:read, ProductType.new)
    end

    it "should not be able to edit product types" do
      @ability.should_not be_able_to(:edit, ProductType.new)
    end

    it "should be able to read business units" do
      @ability.should be_able_to(:read, BusinessUnit.new)
    end

    it "should not be able to edit business units" do
      @ability.should_not be_able_to(:edit, BusinessUnit.new)
    end

    it "should be able to read people" do
      @ability.should be_able_to(:read, Person.new)
    end

    it "should not be able to edit arbitrary people" do
      @ability.should_not be_able_to(:edit, Person.new)
    end

    it "should be able to read purchases" do
      @ability.should be_able_to(:read, Purchase.new)
    end

    it "should be able to read debts" do
      @ability.should be_able_to(:read, Debt.new)
    end

    it "should not be able to manage purchases" do
      @ability.should_not be_able_to(:manage, Purchase.new)
    end

    it "should not be able to manage debts" do
      @ability.should_not be_able_to(:manage, Debt.new)
    end

    it "should be able to create new purchases for itself" do
      @ability.should be_able_to(:create, @user.purchases.new)
      @ability.should be_able_to(:edit, @user.purchases.new)
    end

    it "should be able to view its own purchases" do
      @ability.should be_able_to(:show, @user.purchases.new)
    end

    it "should not be able to confirm its own purchases" do
      @ability.should_not be_able_to(:confirm, @user.purchases.new)
    end

    it "should not be able to pay/bookkeep its own purchases" do
      @ability.should_not be_able_to(:pay, @user.purchases.new(:workflow_state => "confirmed"))
      @ability.should_not be_able_to(:keep, @user.purchases.new(:workflow_state => "confirmed"))
    end
    it "should not be able to cancel its own purchases" do
      @ability.should_not be_able_to(:cancel, @user.purchases.new)
    end
  end
end
