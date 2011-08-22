class BudgetPost < ActiveRecord::Base
  has_many :budget_rows
  belongs_to :business_unit

  accepts_nested_attributes_for :budget_rows

  after_create :create_rows

  default_scope order("name ASC")

  def to_s
    name
  end

  def self.all_years
    Purchase.group(:year).select(:year).map do |y|
      y.year
    end
  end 

  def row(year)
    budget_rows.find_by_year(year)
  end

protected

  def create_rows
    BudgetPost.all_years.each do |y|
      BudgetRow.create(:budget_post=>self, :year => y)
    end
  end
end
