require 'spec_helper'

describe BudgetRowsHelper, type: :helper do
  describe 'budget row urls' do
    it 'should add its year to the generated link' do
      budget_post = Factory :budget_post
      row = budget_post.row(Time.now.year)

      expect(helper.row_url(row)).to eq(budget_row_path(budget_id: Time.now.year, id: row.id))
    end
  end
end
