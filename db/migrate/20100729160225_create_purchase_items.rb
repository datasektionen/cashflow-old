class CreatePurchaseItems < ActiveRecord::Migration
  def self.up
    create_table :purchase_items do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :purchase_items
  end
end
