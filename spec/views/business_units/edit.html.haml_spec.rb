require 'spec_helper'
require 'mage_api'

describe 'business_units/edit.html.haml' do
  before(:each) do
    initialize_mage_webmock
    @business_unit = assign(:business_unit, stub_model(BusinessUnit,
                                                       :new_record? => false
    ))
  end

  it 'renders the edit business_unit form' do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select 'form', action: business_unit_path(@business_unit), method: 'post'
  end
end
