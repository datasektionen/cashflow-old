require "spec_helper"

describe BudgetPost do
  describe "all_years" do
    it "should contain all years for which there are purchases" do
      p1 = Factory :purchase, year: Time.now.year
      p2 = Factory :purchase, purchased_at: 1.year.ago

      BudgetPost.all_years.should == [p1.year, p2.year]
    end

    it "should contain all years for which there are budget rows" do
      b1 = Factory :budget_row

      BudgetPost.all_years.should == [b1.year]
    end
  end

  pending "write some more specs"
end
