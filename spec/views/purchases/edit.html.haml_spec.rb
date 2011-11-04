require 'spec_helper'

describe "purchases/edit.html.haml" do
  before(:each) do
    budget_post = stub_model(BudgetPost, id: 1, name: "foo", business_unit: stub_model(BusinessUnit))
    @purchase = assign(:purchase, stub_model(Purchase, {:new_record? => false, :slug => "testslug", :budget_post => budget_post}))
    view.should_receive(:budget_posts).at_least(:once).and_return([budget_post])
  end

  it "renders the edit purchase form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => purchase_path(@purchase), :method => "post" do
    end
  end
end
