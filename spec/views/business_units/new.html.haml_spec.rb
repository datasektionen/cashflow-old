require 'spec_helper'
require 'mage_api'

describe 'business_units/new.html.haml' do
  before(:each) do
    initialize_mage_webmock
    assign(:business_unit, stub_model(BusinessUnit).as_new_record)
  end

  it 'renders new business_unit form' do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select 'form', action: business_units_path, method: 'post' do
    end
  end
end
