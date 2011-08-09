class CreateBudgetPosts < ActiveRecord::Migration
  def self.up
    create_table :budget_posts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :budget_posts
  end
end
