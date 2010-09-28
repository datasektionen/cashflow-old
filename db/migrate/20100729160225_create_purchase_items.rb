class CreatePurchaseItems < ActiveRecord::Migration
  def self.up
    create_table :purchase_items do |t|
      t.references  :product_type,  :null => false
      t.references  :purchase,      :null => false
      t.decimal     :amount,        :null => false, :scale => 2, :precision => 20
      t.string      :comment,       :null => false, :default => ""
      t.timestamps
    end
  end

  def self.down
    drop_table :purchase_items
  end
end
