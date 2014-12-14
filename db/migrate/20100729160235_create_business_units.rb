class CreateBusinessUnits < ActiveRecord::Migration
  def self.up
    create_table :business_units do |t|
      t.string :name, null: false
      t.string :short_name, null: false, unique: true
      t.text :description, null: false
      t.boolean :active, null: false, default: true
      t.string :email, null: false, default: ''
      t.integer :mage_number, null: false
      t.string :mage_default_series, null: false
      t.timestamps
    end
  end

  def self.down
    drop_table :business_units
  end
end
