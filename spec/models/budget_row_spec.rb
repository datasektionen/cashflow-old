require "spec_helper"

RSpec.describe BudgetRow do

  it "is invalid if sum is negative" do
    row = BudgetRow.new sum: -1
    expect(row).to be_invalid
    expect(row.errors.messages.keys).to include(:sum)
  end

  describe "#total" do
    let(:person) { create(:person) }

    before(:each) do
      PaperTrail.whodunnit = person.id
    end

    after(:all) do
      PaperTrail.whodunnit = nil
    end

    before(:each) do
      year = Time.now.year
      @purchase = create(:purchase, year: year)
      create(:purchase_item, amount: 100, purchase_id: @purchase.id)
      @purchase.save

      @budget_row = @purchase.budget_post.budget_rows.find_by_year(year)
    end

    context "irrelevant purchases" do
      %w(new edited cancelled).each do |state|
        it "doesn't include edited purchases" do
          @purchase.update_attribute(:workflow_state, state)

          expect(@budget_row.total).to eq(0)
        end
      end
    end

    context "relevant purchases" do
      %w(confirmed paid bookkept finalized).each do |state|
        it "includes #{state} purchases" do
          @purchase.update_attribute(:workflow_state, state)

          expect(@budget_row.total.to_f).to eq(100)
        end
      end
    end
  end
end
