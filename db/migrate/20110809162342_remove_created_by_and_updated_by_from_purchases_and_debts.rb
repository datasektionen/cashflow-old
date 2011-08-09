class RemoveCreatedByAndUpdatedByFromPurchasesAndDebts < ActiveRecord::Migration
  def self.up
    remove_column :purchases, :created_by_id
    remove_column :purchases, :updated_by_id
    remove_column :debts,     :created_by_id
  end

  def self.down
    add_column :purchases, :created_by_id, :integer
    add_column :purchases, :updated_by_id, :integer
    add_column :debts,     :created_by_id, :integer
  end
end
