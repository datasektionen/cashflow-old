Given /^budget rows exist with the following attributes:$/ do |table|
  table.hashes.each do |hash|
    post_name = hash.delete("budget_post_name")
    Factory :budget_row, hash.merge(:budget_post => Factory(:budget_post, :name => post_name))
  end
end

