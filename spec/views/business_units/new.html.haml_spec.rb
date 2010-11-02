require 'spec_helper'

describe "business_units/new.html.haml" do
  before(:each) do
    assign(:business_unit, stub_model(BusinessUnit).as_new_record)
  end

  it "renders new business_unit form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => business_units_path, :method => "post" do
    end
  end
end
