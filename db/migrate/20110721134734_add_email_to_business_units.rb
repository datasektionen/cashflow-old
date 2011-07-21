class AddEmailToBusinessUnits < ActiveRecord::Migration
  def self.up
    add_column :business_units, :email, :string
  end

  def self.down
    remove_column :business_units, :email
  end
end
