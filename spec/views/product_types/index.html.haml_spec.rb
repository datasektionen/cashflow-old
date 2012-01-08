require 'spec_helper'

describe "product_types/index.html.haml" do
  before(:each) do
    product_type = stub_model(ProductType, :to_s => "product_type")
    assign(:product_types, [
      product_type,
      product_type
    ])
  end

  it "renders a list of product_types" do
    render
  end
end
