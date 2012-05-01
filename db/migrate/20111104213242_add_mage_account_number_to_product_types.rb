class AddMageAccountNumberToProductTypes < ActiveRecord::Migration
  def self.up
    add_column :product_types, :mage_account_number, :integer
  end

  def self.down
    remove_column :product_types, :mage_account_number
  end
end
