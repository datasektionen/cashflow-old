class CreateProductTypes < ActiveRecord::Migration
  def self.up
    create_table :product_types do |t|
      t.string :name,        :null => false
      t.string :description, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :product_types
  end
end
