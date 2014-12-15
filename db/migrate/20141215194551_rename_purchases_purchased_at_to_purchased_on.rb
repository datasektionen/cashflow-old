class RenamePurchasesPurchasedAtToPurchasedOn < ActiveRecord::Migration
  def change
    rename_column :purchases, :purchased_at, :purchased_on
  end
end
