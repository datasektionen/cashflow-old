steps_for :delete_budget_posts do
  use_steps :login
  use_steps :budget_posts
  use_steps :purchases
end
