require 'spec_helper'
require 'mage_api'

describe 'product_types/edit.html.haml' do
  before(:each) do
    initialize_mage_webmock
    @product_type = assign(:product_type, stub_model(ProductType,
                                                     :new_record? => false
    ))
  end

  it 'renders the edit product_type form' do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select 'form', action: product_type_path(@product_type), method: 'post' do
    end
  end
end
