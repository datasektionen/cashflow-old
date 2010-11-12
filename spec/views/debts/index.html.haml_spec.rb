require 'spec_helper'

describe "debts/index.html.haml" do
  before(:each) do
    assign(:debts, [
      stub_model(Debt),
      stub_model(Debt)
    ])
  end

  it "renders a list of debts" do
    render
  end
end
