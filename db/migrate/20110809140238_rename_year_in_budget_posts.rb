class RenameYearInBudgetPosts < ActiveRecord::Migration
  def self.up
    #nvm, just remove it..
    remove_column :budget_rows, :activity_year, :year
  end

  def self.down
  end
end
