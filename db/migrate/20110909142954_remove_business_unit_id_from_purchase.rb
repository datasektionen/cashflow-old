class RemoveBusinessUnitIdFromPurchase < ActiveRecord::Migration
  def self.up
    remove_column :purchases, :business_unit_id
  end

  def self.down
    add_column :purchases, :business_unit_id, :integer, :null => false
  end
end
