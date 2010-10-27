require 'spec_helper'

describe Purchase do
  before(:each) do
    @purchase = Factory :purchase
  end
  
  it "should be invalid without an owner" do
    @purchase.person = nil
    @purchase.should_not be_valid
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
