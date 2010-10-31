require 'spec_helper'

describe "product_types/index.html.haml" do
  before(:each) do
    assign(:product_types, [
      stub_model(ProductType),
      stub_model(ProductType)
    ])
  end

  it "renders a list of product_types" do
    render
  end
end
