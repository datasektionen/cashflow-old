Given /^a budget post exists without any purchases$/ do
  @budget_post = Factory :budget_post
end

Given /^a budget post exists with a bunch of purchases$/ do
  Given 'a budget post exists without any purchases'
  Given 'a purchase'
end

When /^I try to delete it$/ do
  visit('/budget_posts')
  within(:xpath, "//form[@action='/budget_posts/#{@budget_post.id}']") do
    click_on('Ta bort')
    page.driver.browser.switch_to.alert.accept
  end
end

Then /^it should not be deleted$/ do
  pending('TODO: fix mysql wait bug')
  BudgetPost.exists?(@budget_post.id).should be_true
end

Then /^I should get a message saying so$/ do
  page.should have_content('kunde inte tas bort')
end

Then /^it should be deleted$/ do
  page.should have_content('Budgetpost borttagen')
  BudgetPost.exists?(@budget_post.id).should be_false
end
