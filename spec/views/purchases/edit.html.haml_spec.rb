require 'spec_helper'

describe "purchases/edit.html.haml" do
  before(:each) do
    @purchase = assign(:purchase, stub_model(Purchase,
      :new_record? => false
    ))
  end

  it "renders the edit purchase form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => purchase_path(@purchase), :method => "post" do
    end
  end
end
