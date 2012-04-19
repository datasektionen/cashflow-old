class AddMageNumberToBusinessUnits < ActiveRecord::Migration
  def self.up
    add_column :business_units, :mage_number, :integer
  end

  def self.down
    remove_column :business_units, :mage_number
  end
end
