class BudgetController < ApplicationController
  before_filter :get_or_set_year

  def index
    redirect_to budget_path(:id => @year)
  end

  def show
    @budget_rows = BudgetRow.year(@year)
  end

  def edit
    @budget_rows = BudgetRow.year(@year)
  end

  protected
  def get_or_set_year
    @year = params[:id] || Time.now.year
  end
end
