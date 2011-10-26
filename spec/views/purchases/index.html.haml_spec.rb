require 'spec_helper'

describe "purchases/index.html.haml" do
  before(:each) do
    assign(:purchases, [
      Factory(:purchase), Factory(:purchase)
    ])
  end

  it "renders a list of purchases" do
    render
  end
end
