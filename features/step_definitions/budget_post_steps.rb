Given(/^a budget post exists without any purchases$/) do
  @budget_post = Factory :budget_post
end

Given(/^a budget post exists with a bunch of purchases$/) do
  Given 'a purchase'
  @budget_post = @purchase.budget_post
  # Given 'a budget post exists without any purchases'
end

When(/^I try to delete the budget post$/) do
  visit('/budget_posts')
  href = "/budget_posts/#{@budget_post.id}"
  link = page.all(:xpath, "//a[@href='#{href}' and @data-method='delete']")[0]
  link.click
  page.driver.browser.switch_to.alert.accept
end

Then(/^the budget post should still exist$/) do
  page.should have_content(@budget_post.name)
end

Then(/^I should get a message saying so$/) do
  page.should have_content('kunde inte tas bort')
end

Then(/^the budget post should be deleted$/) do
  page.should have_content('Budgetpost borttagen')
  # page.should have_no_content(@budget_post.name)
  BudgetPost.exists?(@budget_post.id).should be_false
end
