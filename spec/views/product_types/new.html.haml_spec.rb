require 'spec_helper'

describe "product_types/new.html.haml" do
  before(:each) do
    assign(:product_type, stub_model(ProductType).as_new_record)
  end

  it "renders new product_type form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => product_types_path, :method => "post" do
    end
  end
end
