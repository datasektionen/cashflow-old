class BudgetRow < ActiveRecord::Base
  belongs_to :budget_post

  def total
    return @amount if @amount
    @amount = 0
    purchases.each do |p|
      @amount += p.total
    end
    @amount
  end

  def self.create_rows_if_not_exists(year)
    BudgetPost.all.each do |bp|
      unless find_by_budget_post_id_and_year(bp.id, year)
        create(:budget_post=>bp, :year=>year) 
      end
    end
  end
end
