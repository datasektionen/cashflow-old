class AddMageNumberToBudgetPosts < ActiveRecord::Migration
  def self.up
    add_column :budget_posts, :mage_arrangement_number, :integer
  end

  def self.down
    remove_column :budget_posts, :mage_arrangement_number
  end
end
