require "rails_helper"

RSpec.describe "Manage budgets", type: :feature, js: true, slow: true do
  include ActiveSupport::NumberHelper

  let(:person) { create(:person, role: "treasurer") }
  let(:rows_from_current_year) do
    create_list(:budget_row, 2, year: Time.now.year, sum: 100)
  end
  let(:row_from_last_year) do
    create(:budget_row, year: Time.now.year - 1, sum: 300) 
  end

  before(:each) { BudgetPost.skip_callback(:create, :after, :create_rows) }
  after(:each) { BudgetPost.set_callback(:create, :after, :create_rows) }

  before(:each) do
    login_as person
  end

  scenario "View the budget for the current year" do
    visit budget_path(Time.now.year)

    rows_from_current_year.each do |row|
      expect(page).to have_content(row.budget_post.name)
      expect(page).to have_content(row.sum)
    end

    expect(page).to have_no_content(row_from_last_year.budget_post.name)
  end

  scenario "View the budget for last year" do
    visit budget_path(Time.now.year - 1)

    expect(page).to have_content(row_from_last_year.budget_post.name)

    rows_from_current_year.each do |row|
      expect(page).to have_no_content(row.budget_post.name)
      expect(page).to have_no_content(row.sum)
    end
  end

  scenario "Edit the budget for the current year" do
    visit budget_path(Time.now.year)

    click_link("Redigera budget")
    find(:css, "#budget_rows_#{rows_from_current_year.first.id}_sum").set(4711)
    click_button("Spara")

    expect(page.current_path).to eq(budget_path(Time.now.year))
    expect(page).to have_content(number_to_currency(4711))
  end
end
