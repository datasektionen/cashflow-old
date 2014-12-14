class CreateBudget < ActiveRecord::Migration
  def self.up
    create_table :budget_posts do |t|
      t.integer :business_unit_id, null: false
      t.string :name, null: false
      t.integer :mage_arrangement_number, null: false
    end

    create_table :budget_rows do |t|
      t.integer :budget_post_id, null: false
      t.integer :year, null: false
      t.integer :sum, null: false, default: 0
    end
  end

  def self.down
    drop_table :budget_posts
    drop_table :budget_rows
  end
end
