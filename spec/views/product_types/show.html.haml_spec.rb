require 'spec_helper'

describe "product_types/show.html.haml" do
  before(:each) do
    @product_type = assign(:product_type, stub_model(ProductType))
  end

  it "renders attributes in <p>" do
    render
  end
end
