require 'spec_helper'

describe PurchaseItem do
  before(:each) do
    @item = Factory :purchase_item
  end
  
  %w[purchase product_type].each do |relation|
    it "should belong to a #{relation}" do
      @item.send(relation).should_not be_nil
      @item.send("#{relation}=", nil)
      @item.should_not be_valid
      @item.errors[relation.to_sym].should_not be_empty
    end
  end
  
  %w[amount comment].each do |attr|
    it "should be invalid without a value for #{attr}" do
      @item.send("#{attr}=",nil)
      @item.should be_invalid
      @item.errors[attr.to_sym].should_not be_empty
    end
  end
  
end
