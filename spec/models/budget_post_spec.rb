require "spec_helper"

describe BudgetPost do
  describe "all_years" do
    before(:each) do
      DatabaseCleaner.start
    end

    after(:each) do
      DatabaseCleaner.clean
    end

    it "should contain all years for which there are purchases" do
      p1 = create(:purchase, year: Time.now.year)
      p2 = create(:purchase, purchased_on: 1.year.ago)

      expect(BudgetPost.all_years).to eq([p1.year, p2.year])
    end

    it "should contain all years for which there are budget rows" do
      b1 = create(:budget_row)

      expect(BudgetPost.all_years).to eq([b1.year])
    end
  end

  it "is invalid without a mage_arrangemen_number" do
    post = create(:budget_post)
    post.mage_arrangement_number = nil
    expect(post).to be_invalid
  end
end
