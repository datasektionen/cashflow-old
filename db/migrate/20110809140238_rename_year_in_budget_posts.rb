class RenameYearInBudgetPosts < ActiveRecord::Migration
  def self.up
    rename_column :budget_posts, :activity_year, :year
  end

  def self.down
    rename_column :budget_posts, :year, :activity_year
  end
end
