class BudgetController < ApplicationController
  before_filter :get_or_set_year

  before_filter do
    authorize! :read, :budget
  end

  before_filter only: [:edit, :update, :update_multiple] do
    authorize! :manage, :budget
  end

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
      rows = update_multiple(:budget_rows)
      posts = update_multiple(:budget_posts)

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

  def update_multiple(key)
    model = key.to_s.singularize.camelize.constantize
    hash = params[key]
    model.update(hash.keys, hash.values)
  end
end
