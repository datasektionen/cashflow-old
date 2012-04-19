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
    begin
      BudgetRow.connection.transaction do
        params[:budget_rows].each do |k, h|
          unless BudgetRow.find(k).update_attributes(h)
            raise ActiveRecord::Rollback
          end
        end
      end
      BudgetPost.connection.transaction do
        params[:budget_posts].each do |k, h|
          unless BudgetPost.find(k).update_attributes(h)
            raise ActiveRecord::Rollback
          end
        end
      end
      redirect_to budget_path(id: @year)
    rescue
      edit
      render 'edit'
    end
  end

  protected
  def get_or_set_year
    @year = params[:id] || Time.now.year
  end
end
