# encoding: utf-8
def validate_visible_budget_posts(year)
  this_years_budget_rows = BudgetRow.year(year)
  other_budget_rows = BudgetRow.where("year not in (#{year})").all

  this_years_budget_rows.each do |row|
    page.should have_content(row.budget_post.name)
  end

  other_budget_rows.each do |row|
    page.should_not have_content(row.budget_post.name)
  end
end

Given /^budget rows exist with the following attributes:$/ do |table|
  table.hashes.each do |hash|
    budget_post = Factory :budget_post, name: hash['budget_post_name']
    budget_post.budget_rows.destroy_all
    year = Time.now.year + hash.delete('year_offset').to_i
    Factory :budget_row, year: year, budget_post: budget_post, sum: hash['sum']
  end
end

Then /^I should be on the budget page for the current year$/ do
  assert_equal URI.parse(current_url).path, budget_path(Time.now.year)
end

When /^I go to the budget page$/ do
  visit(budget_index_path)
end

When /^I go to the budget page for last year$/ do
  visit(budget_path(Time.now.year - 1))
end

Then /^I should see the current year's budget posts$/ do
  validate_visible_budget_posts(Time.now.year)
end

Then /^I should see the budget posts for last year$/ do
  validate_visible_budget_posts(Time.now.year - 1)
end

When /^I change the sum of "([^"]*)" to "([^"]*)"$/ do |_label, sum|
  pending('TODO: add links to budget editing feature')
  click_button('edit_budget')
  fill_in('Alpha', with: sum)
  click_button('Spara')
end
