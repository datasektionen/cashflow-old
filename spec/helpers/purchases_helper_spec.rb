require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the PurchasesHelper. For example:
#
# describe PurchasesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe PurchasesHelper do
  describe 'budget posts for purchase' do
    it "returns the available budget posts to the purchase's business unit" do
      budget_posts = [create(:budget_post), create(:budget_post)]
      business_unit = stub_model(BusinessUnit, budget_posts: budget_posts)
      purchase = stub_model(Purchase, business_unit: business_unit, budget_post: budget_posts.first)

      helper.budget_posts_for_purchase(purchase).should == budget_posts
    end

    it "returns nil if the purchase doesn't have a budget post" do
      purchase = stub_model(Purchase)
      helper.budget_posts_for_purchase(purchase).should be nil
    end
  end

  describe 'originator' do
    it "returns a link to a given purchase version's originator" do
      person = stub_model(Person, id: 37, login: 'foobar', first_name: 'foo', last_name: 'bar')
      version = OpenStruct.new(purchase_date: Time.now, originator: person, workflow_state: 'New')
      helper.link_to_originator(version).should == link_to(version.originator.name, person_path(version.originator))
    end

    it 'returns an empty string when originator is missing' do
      version = OpenStruct.new
      helper.link_to_originator(version).should == ''
    end
  end
end
