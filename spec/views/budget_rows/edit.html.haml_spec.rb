require 'spec_helper'

describe "budget_rows/edit.html.haml" do
  before(:each) do
    @year = assign(:year, Time.now.year)
    @budget_row = assign(:budget_row, stub_model(BudgetRow, budget_post: stub_model(BudgetPost)))
  end

  pending "TODO: add examples"
end
