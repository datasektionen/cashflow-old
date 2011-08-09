class BudgetRow < ActiveRecord::Base
  belongs_to :budget_post
  #has_many :purchases, :through=>:budget_post, :conditions=>["purchases.year = budget_rows.year"]

  def total
    return @amount if @amount
    @amount = 0
    purchases.each do |p|
      @amount += p.total
    end
    @amount
  end
end
