class PurchaseItem < ActiveRecord::Base
  belongs_to :purchase
  belongs_to :product_type
  
  validates_presence_of :amount, :product_type
  validates_numericality_of :amount, greater_than_or_equal_to: 0.1, less_than_or_equal_to: 100_000.0
end
