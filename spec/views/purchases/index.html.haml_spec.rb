require 'spec_helper'

describe "purchases/index.html.haml" do
  before(:each) do
    assign(:purchases, [
      stub_model(Purchase),
      stub_model(Purchase)
    ])
  end

  it "renders a list of purchases" do
    render
  end
end
