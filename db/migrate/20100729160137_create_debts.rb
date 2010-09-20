class CreateDebts < ActiveRecord::Migration
  def self.up
    create_table :debts do |t|
      t.string      :description,   :null => false
      t.integer     :created_by,    :null => false
      t.integer     :amount,        :null => false
      t.references  :person,        :null => false
      t.references  :business_unit, :null => false
      t.string      :workflow_state,:null => false, :default => "new"
      t.timestamps
    end
  end

  def self.down
    drop_table :debts
  end
end
