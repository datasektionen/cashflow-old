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
  
  it "should not be cancelable once paid" do
    @debt.pay!
    @debt.should be_valid
    @debt.should be_paid
    pending "TODO: validate what transitions are available or something."
  end
end
