class BudgetPost < ActiveRecord::Base
  has_many :budget_rows
  belongs_to :business_unit
end
