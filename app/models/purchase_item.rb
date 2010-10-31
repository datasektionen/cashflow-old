class PurchaseItem < ActiveRecord::Base
  belongs_to :purchase
  belongs_to :product_type
  
  validates_presence_of :amount, :comment, :purchase, :product_type
end
