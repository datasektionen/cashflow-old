class RemoveDebts < ActiveRecord::Migration
  def up
    drop_table(:debts)
  end

  def down
    create_table :debts do |t|
      t.string :description, null: false
      t.integer :amount, null: false, scale: 2, precision: 20
      t.references :person, null: false
      t.references :business_unit, null: false
      t.string :workflow_state, null: false, default: 'new'
      t.timestamps
    end
  end
end
