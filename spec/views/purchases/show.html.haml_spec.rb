require 'spec_helper'

describe "purchases/show.html.haml" do
  before(:each) do
    @purchase = assign(:purchase, stub_model(Purchase))
  end

  it "renders attributes in <p>" do
    render
  end
end
