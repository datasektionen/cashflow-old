require 'spec_helper'

describe "debts/show.html.haml" do
  before(:each) do
    @debt = assign(:debt, stub_model(Debt))
  end

  # TODO: lookup whether we need to set current_ability
  it "renders attributes in <p>" do
    render
  end
end
