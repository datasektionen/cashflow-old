require 'spec_helper'

describe "purchases/new.html.haml" do
  before(:each) do
    budget_post = stub_model(BudgetPost, id: 1, name: "foo", business_unit: stub_model(BusinessUnit))
    view.should_receive(:budget_posts).at_least(:once).and_return([budget_post])
    assign(:purchase, stub_model(Purchase).as_new_record)
  end

  it "renders new purchase form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => purchases_path, :method => "post" do
    end
  end
end
