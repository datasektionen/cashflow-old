class ReaddYearToBudgetPosts < ActiveRecord::Migration
  def self.up
    add_column :budget_rows, :year, :integer, :null=>false
  end

  def self.down
    remove_column :budget_rows, :year
  end
end
