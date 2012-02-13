#encoding: utf-8
steps_for :budget do
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


  step "budget rows exist with the following attributes:" do |table|
    table.hashes.each do |hash|
      budget_post = Factory :budget_post, name: hash['budget_post_name']
      budget_post.budget_rows.destroy_all
      year = Time.now.year + hash.delete("year_offset").to_i
      row = Factory :budget_row, 
                    year: year,
                    budget_post: budget_post,
                    sum: hash['sum']
    end
  end

  step "I should be on the budget page for the current year" do
    assert_equal URI.parse(current_url).path, budget_path(Time.now.year)
  end

  step "I go to the budget page" do
    visit(budget_index_path)
  end

  step "I go to the budget page for last year" do
    visit(budget_path(Time.now.year - 1))
  end

  step "I should see the current year's budget posts" do
    validate_visible_budget_posts(Time.now.year)
  end

  step "I should see the budget posts for last year" do
    validate_visible_budget_posts(Time.now.year - 1)
  end

  step "I change the sum of \":label\" to \":sum\"" do |label, sum|
    click_button("edit_budget")
    fill_in("Alpha", with: sum)
    click_button("Spara")
  end

end

