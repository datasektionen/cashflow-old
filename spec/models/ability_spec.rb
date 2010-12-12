require "spec_helper"
require 'cancan/matchers'

describe Ability do
  describe "admin" do
    before(:each) do
      @user = Factory(:admin)
      @ability = Ability.new(@user)
    end
    it "should be able to manage people" do
      @ability.should be_able_to(:manage, Person.new)
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

    it "should be able to manage product types" do
      @ability.should be_able_to(:manage, ProductType.new)
    end
  end

  describe "ordinary user" do
    before(:each) do
      @user = Factory(:person)
      @ability = Ability.new(@user)
    end

    it "should be able to read product types" do
      @ability.should be_able_to(:read, ProductType.new)
    end

    it "should not be able to edit product types" do
      @ability.should_not be_able_to(:edit, ProductType.new)
    end
  end

  describe "accountant" do
    before(:each) do
      @user = Factory(:accountant)
      @ability = Ability.new(@user)
    end

    it "should be able to read product types" do
      @ability.should be_able_to(:read, ProductType.new)
    end

    it "should not be able to edit product types" do
      @ability.should_not be_able_to(:edit, ProductType.new)
    end
  end
end
