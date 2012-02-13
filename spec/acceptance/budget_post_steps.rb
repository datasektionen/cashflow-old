steps_for :budget_posts do
  step "a budget post exists without any purchases" do
    @budget_post = Factory :budget_post
  end

  step "a budget post exists with a bunch of purchases" do
    step 'a budget post exists without any purchases'
    step 'a purchase'
  end

  step "I try to delete it" do
    visit("/budget_posts")
    within(:xpath, "//form[@action='/budget_posts/#{@budget_post.id}']") do
      click_on("Ta bort")
      page.driver.browser.switch_to.alert.accept
    end
  end

  step "it should not be deleted" do
    BudgetPost.exists?(@budget_post.id).should be_true
  end

  step "it should be deleted" do
    page.should have_content("Budgetpost borttagen")
    BudgetPost.exists?(@budget_post.id).should be_false
  end
end

