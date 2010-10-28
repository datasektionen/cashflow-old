require 'spec_helper'

describe Debt do
  before(:each) do
    @debt = Factory :debt
  end
  
  %w[description amount].each do |attribute|
    it "should be invalid without an attribute #{attribute}" do
      @debt.send("#{attribute}=", nil)
      @debt.should be_invalid
      @debt.errors[attribute.to_sym].should_not be_empty
    end
  end

  %w[author person business_unit].each do |relation|
    it "should be invalid without a relation #{relation}" do
      @debt.send(relation).should_not be_nil
      @debt.send("#{relation}=",nil)
      @debt.should be_invalid
      @debt.errors[relation.to_sym].should_not be_empty
    end
  end

  it "should have a starting workflow_state \"new\"" do
    @debt.workflow_state.should == "new"
  end
  
  it "should be cancelable when new" do
    @debt.cancel!
    @debt.save
    @debt.should be_valid
    @debt.should be_cancelled
  end
  
  it "should not be editable once finalized" do
    @debt.update_attribute(:workflow_state, "finalized")
    @debt.save.should be_false
  end
  
  # finalized not present here since a Debt should never be editable at all when finalized
  %w[paid bookkept cancelled].each do |state|
    it "should not be cancelable once #{state}" do
      @debt.workflow_state = state
      @debt.save
      @debt.should be_valid
      @debt.send("#{state}?").should be_true
      lambda {@debt.cancel!}.should raise_error(Workflow::NoTransitionAllowed)
    end
  end
  
  it "should not allow mass update of workflow state" do
    attrs = {:workflow_state => "foobar"}
    @debt.update_attributes(attrs)
    @debt.save
    @debt.should be_valid
    @debt.workflow_state.should_not == "foobar"
  end
  
  %w[new bookkept].each do |state|
    it "should be payable if #{state}" do
      @debt.workflow_state = state
      @debt.save
      @debt.should be_valid
      lambda {@debt.pay!}.should_not raise_error
    end
  end
  
  %w[new paid].each do |state|
    it "should be 'bookkeepable' if #{state}" do
      @debt.workflow_state = state
      @debt.save
      @debt.should be_valid
      lambda {@debt.keep!}.should_not raise_error
    end
  end
  
  it "should get finalized when paid and bookkept" do
    @debt.workflow_state = "paid"
    @debt.save
    @debt.should be_valid
    lambda {@debt.keep!}.should_not raise_error
    @debt.should be_finalized
    
    @debt.workflow_state = "bookkept"
    @debt.save
    @debt.should be_valid
    lambda {@debt.pay!}.should_not raise_error
    @debt.should be_finalized
  end
  
  it "should not ever change owner" do
    @debt.person.should_not be_nil
    @debt.should be_valid
    
    new_person = Factory :person
    @debt.update_attributes(:person_id => new_person.id)
    @debt.save.should be_true
    @debt.reload.person.should_not ==(new_person)

    @debt.person = new_person
    @debt.save.should be_true
    @debt.reload.person.should_not ==(new_person)
  end
end
