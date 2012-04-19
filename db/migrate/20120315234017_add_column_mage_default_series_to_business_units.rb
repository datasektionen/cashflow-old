class AddColumnMageDefaultSeriesToBusinessUnits < ActiveRecord::Migration
  def change
    add_column :business_units, :mage_default_series, :string
  end
end
