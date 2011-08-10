class BudgetRow < ActiveRecord::Base
  belongs_to :budget_post

  def purchases
    Purchase.where(:budget_post_id=>budget_post, :year=>year)
  end

  def sum
    read_attribute(:sum) or 0
  end

  def total
    return @amount if @amount
    @amount = 0
    purchases.confirmed.each do |p|
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
