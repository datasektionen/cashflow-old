class BudgetPost < ActiveRecord::Base
  has_many :budget_rows
  belongs_to :business_unit

  scope :business_unit, lambda { |bu| where(:business_unit_id => bu) }
end
