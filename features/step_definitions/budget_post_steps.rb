Given(/^a budget post exists without any purchases$/) do
  @budget_post = create(:budget_post)
end

Given(/^a budget post exists with a bunch of purchases$/) do
  step "a purchase"
  @budget_post = @purchase.budget_post
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
  expect(BudgetPost.exists?(@budget_post.id)).to eq(false)
end
