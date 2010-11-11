require 'spec_helper'

describe ApplicationHelper do
  describe "swedish money formatting" do
    it "should render monetary values with two decimal spaces and correct unit" do
      helper.currency(100).should == "100,00 kr"
      helper.currency(1_000_000).should == "1 000 000,00 kr"
      helper.currency(3.14).should == "3,14 kr"
    end
  end
end
