class AddSumToBudgetRows < ActiveRecord::Migration
  def self.up
    add_column :budget_rows, :sum, :integer
  end

  def self.down
    remove_column :budget_rows, :sum
  end
end
