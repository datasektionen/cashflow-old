require 'spec_helper'

RSpec.describe BusinessUnit do
  before(:each) do
    @business_unit = create(:business_unit)
  end

  it { is_expected.to respond_to(:email) }

  %w(name short_name description).each do |attribute|
    it "should be invalid with a nil #{attribute}" do
      @business_unit.send("#{attribute}=", nil)
      expect(@business_unit).to be_invalid
      expect(@business_unit.errors[attribute.to_sym]).not_to be_empty
    end
  end
end
