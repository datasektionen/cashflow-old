require 'spec_helper'

describe BudgetRow do

  it "is invalid if sum is negative" do
    row = BudgetRow.new sum: -1
    row.should be_invalid
    row.errors.messages.keys.should include(:sum)
  end

  describe '#total' do
    let(:person) { Factory :person }

    before(:all) do
      PaperTrail.whodunnit = person.id
    end

    after(:all) do
      PaperTrail.whodunnit = nil
    end

    before(:each) do
      stub_request(:post, 'http://localhost:8981/solr/update?wt=ruby').to_return(status: 200, body: '')
      @purchase = Factory :purchase, year: Time.now.year
      Factory :purchase_item, amount: 100, purchase_id: @purchase.id
      @purchase.save

      @budget_row = @purchase.budget_post.budget_rows.find_by_year(Time.now.year)
    end

    context 'irrelevant purchases' do
      %w(new edited cancelled).each do |state|
        it "doesn't include edited purchases" do
          @purchase.update_attribute(:workflow_state, state)

          @budget_row.total.should == 0
        end
      end
    end

    context 'relevant purchases' do
      %w(confirmed paid bookkept finalized).each do |state|
        it "includes #{state} purchases" do
          @purchase.update_attribute(:workflow_state, state)

          @budget_row.total.to_f.should == 100
        end
      end
    end
  end
end
