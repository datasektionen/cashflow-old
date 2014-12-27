require 'spec_helper'

describe BusinessUnit do
  before(:each) do
    @business_unit = Factory :business_unit
  end

  it { should respond_to(:email) }

  %w(name short_name description).each do |attribute|
    it "should be invalid with a nil #{attribute}" do
      @business_unit.send("#{attribute}=", nil)
      expect(@business_unit).to be_invalid
      expect(@business_unit.errors[attribute.to_sym]).not_to be_empty
    end
  end
end
