require 'spec_helper'

describe PurchasesHelper, type: :helper do
  describe 'budget posts for purchase' do
    it "returns the available budget posts to the purchase's business unit" do
      budget_posts = [Factory(:budget_post), Factory(:budget_post)]
      business_unit = stub_model(BusinessUnit, budget_posts: budget_posts)
      purchase = stub_model(Purchase, business_unit: business_unit, budget_post: budget_posts.first)

      expect(helper.budget_posts_for_purchase(purchase)).to eq(budget_posts)
    end

    it "returns nil if the purchase doesn't have a budget post" do
      purchase = stub_model(Purchase)
      expect(helper.budget_posts_for_purchase(purchase)).to be nil
    end
  end

  describe 'originator' do
    it "returns a link to a given purchase version's originator" do
      person = stub_model(Person, id: 37, login: 'foobar', first_name: 'foo', last_name: 'bar')
      version = OpenStruct.new(purchase_date: Time.now, originator: person, workflow_state: 'New')
      expect(helper.link_to_originator(version)).to eq(link_to(version.originator.name, person_path(version.originator)))
    end

    it 'returns an empty string when originator is missing' do
      version = OpenStruct.new
      expect(helper.link_to_originator(version)).to eq('')
    end
  end
end
