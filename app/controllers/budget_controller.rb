class BudgetController < ApplicationController
  before_filter :get_or_set_year

  def index
    redirect_to budget_path(id: @year)
  end

  def show
    @budget_rows = BudgetRow.year(@year)
  end

  def edit
    @budget_rows = BudgetRow.year(@year)
    @mage_arrangements = Mage::Arrangement.all(@year)
    @mage_arrangements_grouped = @mage_arrangements.group_by(&:organ_number)
  end

  def update
    ActiveRecord::Base.transaction do
      rows = params[:budget_rows]
      posts = params[:budget_posts]

      rows = BudgetRow.update(rows.keys, rows.values)
      posts = BudgetPost.update(posts.keys, posts.values)

      if [rows, posts].flatten.any?(&:invalid?)
        fail ActiveRecord::Rollback
      end
    end

    redirect_to budget_path(id: @year)
  rescue
    edit
    render 'edit'
  end

  protected

  def get_or_set_year
    @year = params[:id] || Time.now.year
  end
end
