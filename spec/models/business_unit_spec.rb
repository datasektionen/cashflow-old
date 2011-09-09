require 'spec_helper'

describe BusinessUnit do
  before(:each) do
    @business_unit = Factory :business_unit
  end
  
  %w[name short_name description].each do |attribute|
    it "should be invalid with a nil #{attribute}" do
      @business_unit.send("#{attribute}=", nil)
      @business_unit.should be_invalid
      @business_unit.errors[attribute.to_sym].should_not be_empty
    end
  end
end
