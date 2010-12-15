class CreatePurchases < ActiveRecord::Migration
  def self.up
    create_table :purchases do |t|
      t.string      :description,       :null => false
      t.string      :workflow_state,    :null => false, :default => "new"
      t.references  :person,            :null => false                    # owner
      t.integer     :created_by_id,     :null => false
      t.integer     :updated_by_id,     :null => false                    # last updated by
      t.references  :business_unit,     :null => false
      t.date        :purchased_at,      :null => false
      t.string      :slug,              :null => false, :default => ""
      t.timestamps
    end
  end

  def self.down
    drop_table :purchases
  end
end
