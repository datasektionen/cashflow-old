require 'spec_helper'

describe 'budget_rows/index.html.haml' do
  before(:each) do
    assign(:year, Time.now.year)
    assign(:budget_rows, [
      stub_model(BudgetRow, year: Time.now.year),
      stub_model(BudgetRow, year: Time.now.year)
    ])
  end

  it 'renders a list of budget_rows' do
    render
  end
end
