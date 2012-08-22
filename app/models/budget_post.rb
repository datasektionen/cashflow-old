class BudgetPost < ActiveRecord::Base
  has_many :purchases, :dependent => :restrict
  has_many :budget_rows, :dependent => :destroy, :order => 'year desc'
  belongs_to :business_unit

  validates :mage_arrangement_number, :presence=>true

  after_create :create_rows

  default_scope order("name ASC")

  def to_s
    name
  end

  # return an array of all years for which there are any budget rows
  def self.all_years
    [Time.now.year] | BudgetRow.group(:year).select(:year).order('year desc').map(&:year)
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
