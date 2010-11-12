require 'spec_helper'

describe "debts/show.html.haml" do
  before(:each) do
    @debt = assign(:debt, stub_model(Debt))
  end

  it "renders attributes in <p>" do
    render
  end
end
