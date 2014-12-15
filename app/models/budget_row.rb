class BudgetRow < ActiveRecord::Base
  belongs_to :budget_post
  delegate :business_unit, to: :budget_post

  scope :year, lambda { |year| includes(budget_post: :purchases).where(year: year) }

  def purchases
    budget_post.purchases.where(year: year)
  end

  def sum
    read_attribute(:sum) || 0
  end

  def total
    return @amount if @amount
    @amount = PurchaseItem.where(purchase_id: purchases.accepted).sum(:amount)
  end

  def self.create_rows_if_not_exists(year)
    BudgetPost.all.each do |bp|
      unless find_by_budget_post_id_and_year(bp.id, year)
        create(budget_post: bp, year: year)
      end
    end
  end
end
