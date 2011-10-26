module BudgetRowsHelper
  def row_url(row)
    year = row.year || Time.now.year
    budget_row_path(budget_id: year, id: row.id)
  end
end
