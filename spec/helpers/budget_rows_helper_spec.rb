require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the BudgetRowsHelper. For example:
#
# describe BudgetRowsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe BudgetRowsHelper do
  describe 'budget row urls' do
    it 'should add its year to the generated link' do
      budget_post = Factory :budget_post
      row = budget_post.row(Time.now.year)

      expect(helper.row_url(row)).to eq(budget_row_path(budget_id: Time.now.year, id: row.id))
    end
  end
end
