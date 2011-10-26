require 'spec_helper'

describe "budget_rows/edit.html.haml" do
  before(:each) do
    @year = assign(:year, Time.now.year)
    @budget_row = assign(:budget_row, stub_model(BudgetRow))
  end

  it "renders the edit budget_row form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => budget_rows_path(budget_id: @year, id: @budget_row), :method => "post" do
    end
  end
end
