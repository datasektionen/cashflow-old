class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :ugid, :null => false
      t.string :login, :null => false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :email, :null => false
      t.string :bank_clearing_number, :null => false, :default => ""
      t.string :bank_account_number, :null => false, :default => ""
      t.string :persistence_token
      t.string :role, :null => false, :default => "user"
      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
