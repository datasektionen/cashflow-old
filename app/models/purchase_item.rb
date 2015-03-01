class PurchaseItem < ActiveRecord::Base
  belongs_to :purchase
  belongs_to :product_type

  validates :product_type, presence: true
  validates :amount,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0.1,
              less_than_or_equal_to: 100_000.0
            }
end
