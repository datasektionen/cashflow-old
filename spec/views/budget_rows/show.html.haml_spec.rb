require 'spec_helper'

describe 'budget_rows/show.html.haml' do
  before(:each) do
    assign(:year, Time.now.year)
    @budget_row = assign(:budget_row, stub_model(BudgetRow, year: Time.now.year, budget_post: stub_model(BudgetPost)))
  end

  it 'renders attributes in <p>' do
    render
  end
end
