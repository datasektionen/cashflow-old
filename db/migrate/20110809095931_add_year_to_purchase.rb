class AddYearToPurchase < ActiveRecord::Migration
  def self.up
 #   add_column :purchases, :year, :integer, :null=>false
 #   Purchase.each do |p|
 #     p.year = p.purchased_at.year
 #   end
  end

  def self.down
    remove_column :purchases, :year
  end
end
