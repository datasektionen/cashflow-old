class BudgetPost < ActiveRecord::Base
  has_many :budget_rows
  belongs_to :business_unit

  accepts_nested_attributes_for :budget_rows

  scope :business_unit, lambda { |bu| where(:business_unit_id => bu) }

  after_create :create_rows

  def self.all_years
    Purchase.group(:year).select(:year).map do |y|
      y.year
    end
  end 
  protected
  def create_rows
    BudgetPost.all_years.each do |y|
      BudgetRow.create(:budget_post=>self, :year => y)
    end
  end
end
