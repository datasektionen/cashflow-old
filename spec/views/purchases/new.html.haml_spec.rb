require 'spec_helper'

describe "purchases/new.html.haml" do
  before(:each) do
    assign(:purchase, stub_model(Purchase).as_new_record)
  end

  it "renders new purchase form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => purchases_path, :method => "post" do
    end
  end
end
