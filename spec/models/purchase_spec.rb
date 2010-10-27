require 'spec_helper'

describe Purchase do
  before(:all) do
    @person = Factory :person
  end
  
  before(:each) do
    @purchase = Factory :purchase
  end
  
  after(:each) do
    @purchase.person.destroy if @purchase.person
    @purchase.destroy
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
  
  pending "TODO: verifiera workflow"
  pending "add some examples to (or delete) #{__FILE__}"
end
