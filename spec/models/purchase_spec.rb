require 'spec_helper'

describe Purchase do
  before(:all) do
    @person = Factory :person
  end
  
  before(:each) do
    @purchase = Factory :purchase
  end
  
  after(:each) do
    @purchase.destroy
    @purchase.person.destroy if @purchase.person
  end
  
  it "should be invalid without an owner" do
    @purchase.person = nil
    @purchase.should_not be_valid
  end

  it "should not ever change owner" do
    new_person = Factory :person
    @purchase.should be_valid
    
    @purchase.person = new_person
    @purchase.save.should be_true
    @purchase.reload.person.should_not ==(new_person)
    
    @purchase.update_attributes(:person_id => new_person.id)
    @purchase.save.should be_true
    @purchase.reload.person.should_not ==(new_person)
  end

  it "should be invalid without a description" do
    @purchase.description = nil
    @purchase.should be_invalid
    @purchase.description = ""
    @purchase.should be_invalid
  end

  it "should be created by someone" do
    @purchase.created_by.should_not be_blank
    @purchase.created_by = nil
    @purchase.should_not be_valid
    @purchase.errors[:created_by].should_not be_empty
  end

  it "should be updated by someone" do
    @purchase.updated_by.should_not be_blank
    @purchase.updated_by = nil
    @purchase.should_not be_valid
    @purchase.errors[:updated_by].should_not be_empty
  end

  it "should belong to a business unit" do
    @purchase.business_unit.should_not be_blank
    @purchase.business_unit = nil
    @purchase.should_not be_valid
    @purchase.errors[:business_unit].should_not be_empty
  end
  
  it "should have a default workflow_state of \"new\"" do
    @purchase.workflow_state.should == "new"
  end

  it "should be purchased at some date" do
    @purchase.purchased_at.should_not be_blank
    @purchase.purchased_at = nil
    @purchase.should_not be_valid
    @purchase.errors[:purchased_at].should_not be_empty
  end
  
  it "should not be purchased in the future" do
    @purchase.purchased_at.should <= Date.today
    @purchase.purchased_at = Date.today + 1
    @purchase.should be_invalid
    @purchase.errors[:purchased_at].should_not be_empty
  end
  
  %w[new edited].each do |state|
    it "should be cancellable when #{state}" do
      @purchase.update_attribute(:workflow_state, state)
      lambda {@purchase.cancel!}.should_not raise_error
    end
  end
  
  %w[new confirmed].each do |state|
    it "should be editable when #{state}" do
      @purchase.update_attribute(:workflow_state, state)
      lambda {@purchase.edit!}.should_not raise_error
    end
  end
  
  %w[new edited].each do |state|
    it "should be confirmable when #{state}" do
      @purchase.update_attribute(:workflow_state, state)
      lambda {@purchase.confirm!}.should_not raise_error
    end
  end
  
  %w[confirmed paid].each do |state|
    it "should be bookkeepable when #{state}" do
      @purchase.update_attribute(:workflow_state, state)
      lambda {@purchase.keep!}.should_not raise_error
    end
  end
  
  %w[confirmed bookkept].each do |state|
    it "should be payable when #{state}" do
      @purchase.update_attribute(:workflow_state, state)
      lambda {@purchase.pay!}.should_not raise_error
    end
  end
  
  it "should be finalized when both paid and bookkept (in any order)" do
    @purchase.update_attribute(:workflow_state, "confirmed")
    lambda {@purchase.pay!}.should_not raise_error
    lambda {@purchase.keep!}.should_not raise_error
    @purchase.should be_finalized
    
    @purchase.update_attribute(:workflow_state, "confirmed")
    lambda {@purchase.keep!}.should_not raise_error
    lambda {@purchase.pay!}.should_not raise_error
    @purchase.should be_finalized
  end
  
  %w[paid bookkept finalized confirmed].each do |state|
    it "should not be cancellable when #{state}" do
      @purchase.update_attribute(:workflow_state, state)
      lambda {@purchase.cancel!}.should raise_error
    end
  end

  %w[cancelled finalized].each do |state|
    %w[confirm pay edit bookkeep].each do |action|
      it "should throw exception on ##{action}! when #{state}" do
        @purchase.update_attribute(:workflow_state, state)
        lambda {@purchase.send("#{action}!")}.should raise_error
      end
    end
  end

  it "should not be editable once finalized" do
    @purchase.update_attribute(:workflow_state, "finalized")
    @purchase.save.should be_false
  end
  
  it "should cascade delete its related purchase items" do
    @purchase.items.should be_empty
    pi = Factory.build(:purchase_item)
    pi.purchase = @purchase
    pi.save

    item = @purchase.reload.items.first
    
    item.should_not be_nil
    
    item_id = item.id
    purchase_id = @purchase.id
    
    @purchase.destroy
    Purchase.exists?(:id => purchase_id).should be_false
    PurchaseItem.exists?(:id => item_id).should be_false
  end

  it "should generate a slug before being saved" do
    @purchase.slug = ''
    @purchase.should be_valid
    @purchase.slug.should_not be_blank
  end

  it "should update the generated slug properly after being saved" do
    @purchase.save
    @purchase.slug.should_not be_blank
    @purchase.slug.should =~ /-#{@purchase.id}$/
  end
end
