require 'spec_helper'

describe Person do
  before(:each) do
    @person = Person.new
  end
  
  it "should have a default role of \"user\"" do
    @person.role.should == "user"
  end
  
  %w[first_name last_name email ugid login role].each do |attribute|
    it "should be invalid without a #{attribute}" do
      @person.send("#{attribute}=", nil)
      @person.should be_invalid
      @person.errors.should_not be_nil
      @person.errors[attribute.to_sym].should_not be_empty
    end
  end

  %w[first_name last_name ugid login role].each do |attribute|
    it "should protect attribute #{attribute}" do
      @person = Factory(:person)
      attr_value = @person.send(attribute)
      @person.update_attributes({attribute.to_sym => "blubb"}).should be_true
      @person.send(attribute).should == attr_value
    end
  end
end
