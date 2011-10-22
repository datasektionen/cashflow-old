class BudgetController < ApplicationController
  before_filter :get_or_set_year

  def index
    redirect_to budget_path(:id => @year)
  end

  def show
    @budget_rows = BudgetRow.year(@year).joins(:budget_post => [:purchases, :business_unit]).includes(:budget_post => [:purchases, :business_unit])
  end

  def edit
    @budget_rows = BudgetRow.year(@year)
  end

  def update
    params[:budget_rows].each do |k, h|
      BudgetRow.find(k).update_attributes(h)
    end
    redirect_to :action => :index
  end

  protected
  def get_or_set_year
    @year = params[:id] || Time.now.year
  end
end
