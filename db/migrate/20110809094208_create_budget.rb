class CreateBudget < ActiveRecord::Migration
  def self.up
    create_table :budget_posts do |t|
      t.integer :business_unit_id, :null=>false
      t.string :name, :null=>false
    end

    create_table :budget_rows do |t|
      t.integer :budget_post_id, :null=>false
      t.integer :activity_year, :null=>false
      t.integer :year, :null=>false
    end

    add_column :purchases,  :budget_post_id, :integer, :null=>false

  end

  def self.down
    remove_column :purchases, :budget_post_id
    drop_table :budget_posts
    drop_table :budget_rows
  end
end
