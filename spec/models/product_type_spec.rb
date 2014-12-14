require 'spec_helper'

describe ProductType do
  before(:each) do
    stub_request(:post, 'http://localhost:8981/solr/update?wt=ruby').to_return(status: 200, body: '')
    @product_type = Factory :product_type
  end
  %w(name description).each do |field|
    it "should be invalid without #{field}" do
      @product_type.send("#{field}=", nil)
      @product_type.should be_invalid
      @product_type.errors[field.to_sym].should_not be_empty
    end
  end

  it 'should have associated purchase items' do
    @product_type.respond_to?(:purchase_items).should be_true
  end

  it 'should not be deletable if it has any associated purchase items' do
    purchase_item = Factory :purchase_item
    purchase_item.product_type = @product_type
    purchase_item.save

    purchase_item.product_type.should == (@product_type)

    product_type_id = @product_type.id
    lambda { @product_type.destroy }.should raise_error
    ProductType.find(product_type_id).should_not be_nil
  end
end
