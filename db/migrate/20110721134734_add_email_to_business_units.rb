class AddEmailToBusinessUnits < ActiveRecord::Migration
  def self.up
    add_column :business_units, :email, :string, :null => false, :default => ""
  end

  def self.down
    remove_column :business_units, :email
  end
end
