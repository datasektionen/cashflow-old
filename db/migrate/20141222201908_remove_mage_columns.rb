class RemoveMageColumns < ActiveRecord::Migration
  def up
    remove_column :budget_posts, :mage_arrangement_number
    remove_column :business_units, :mage_number
    remove_column :business_units, :mage_default_series
    remove_column :product_types, :mage_account_number
  end

  def down
    add_column :budget_posts, :mage_arrangement_number, :integer, null: false
    add_column :business_units, :mage_number, :integer, null: false
    add_column :business_units, :mage_default_series, :string, null: false
    add_column :product_types, :mage_account_number, :integer, null: false
  end
end
