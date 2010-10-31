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
  
  it "should have many purchases" do
    @business_unit.should respond_to(:purchases)
  end
  
  it "should not be deletable if it has any related purchases" do
    purchase = Factory :purchase, :business_unit => @business_unit
    
    business_unit_id = @business_unit.id
    
    lambda {@business_unit.destroy}.should raise_error
    
    BusinessUnit.find(business_unit_id).should_not be_nil
  end
end
