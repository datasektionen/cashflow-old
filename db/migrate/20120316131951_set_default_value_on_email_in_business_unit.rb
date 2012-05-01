class SetDefaultValueOnEmailInBusinessUnit < ActiveRecord::Migration
  def up
    change_column :business_units, :email, :string, :default=>"", :null=>false
  end

  def down
    change_column :business_units, :email, :string, :null=>false
  end
end
