Given /^budget rows exist with the following attributes:$/ do |table|
  table.hashes.each do |hash|
    budget_post = Factory(:budget_post, :name => hash.delete("budget_post_name"))
    year = Time.now.year + hash.delete("year_offset").to_i
    Factory :budget_row, hash.merge(:budget_post => budget_post, :year => year)
  end
end

