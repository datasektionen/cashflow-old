require 'spec_helper'

describe "business_units/show.html.haml" do
  before(:each) do
    @business_unit = assign(:business_unit, stub_model(BusinessUnit))
  end

  it "renders attributes in <p>" do
    render
  end
end
