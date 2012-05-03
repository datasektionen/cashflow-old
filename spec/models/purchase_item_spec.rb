require 'spec_helper'

describe PurchaseItem do
  before(:each) do
    stub_request(:post, "http://localhost:8981/solr/update?wt=ruby").to_return(:status => 200, :body => "")
    @item = Factory :purchase_item
  end
  
  %w[purchase product_type].each do |relation|
    it "should belong to a #{relation}" do
      @item.should belong_to(relation.to_sym)
    end
  end
  
  %w[amount].each do |attr|
    it "should be invalid without a value for #{attr}" do
      @item.send("#{attr}=",nil)
      @item.should be_invalid
      @item.errors[attr.to_sym].should_not be_empty
    end
  end
  
end
