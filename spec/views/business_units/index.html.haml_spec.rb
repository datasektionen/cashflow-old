require 'spec_helper'

describe "business_units/index.html.haml" do
  before(:each) do
    assign(:business_units, [
      stub_model(BusinessUnit),
      stub_model(BusinessUnit)
    ])
  end

  it "renders a list of business_units" do
    render
  end
end
