require 'spec_helper'

describe PurchaseItem do
  before(:each) do
    @item = Factory :purchase_item
  end
  
  %w[purchase].each do |relation|
    it "should belong to a #{relation}" do
      pending "TODO"
    end
  end
  
  pending "add some examples to (or delete) #{__FILE__}"
end
