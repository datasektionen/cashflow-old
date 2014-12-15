class BudgetRowsController < ApplicationController
  load_and_authorize_resource

  before_filter :get_year
  before_filter :get_items, except: [:index]

  def index
    @budget_rows = BudgetRow.year(@year)
  end

  def show
  end

  def edit
  end

  def update
    if @budget_row.update_attributes(params[:budget_row])
      redirect_to(budget_row_path(budget_id: @year, id: @budget_row), notice: 'Budget row was successfully updated.')
    else
      render action: 'edit'
    end
  end

  protected

  def get_year
    @year = params[:budget_id]
  end

  def get_items
    @items = [{ key:  :show_budget,
                name: t('budget_for_year', year: @year),
                url:   budget_path(id: @year)
              },
              { key: :show_budget_row,
                name: @budget_row.budget_post.name,
                url: budget_row_path(budget_id: @budget_row.year, id: @budget_row.id) },
              { key: :edit_budget_row,
                name: I18n.t('edit'),
                url: edit_budget_row_path(budget_id: @budget_row.year, id: @budget_row.id) }
             ]
  end
end
