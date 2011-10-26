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
  end

  def update
    begin
      BudgetRow.connection.transaction do
        params[:budget_rows].each do |k, h|
          unless BudgetRow.find(k).update_attributes(h)
            raise ActiveRecord::Rollback
          end
        end
      end
      redirect_to budget_path(id: @year)
    rescue
      render 'edit'
    end
  end

  protected
  def get_or_set_year
    @year = params[:id] || Time.now.year
  end
end
