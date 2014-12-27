require 'spec_helper'

describe ProductType do
  before(:each) do
    stub_request(:post, 'http://localhost:8981/solr/update?wt=ruby').to_return(status: 200, body: '')
    @product_type = Factory :product_type
  end
  %w(name description).each do |field|
    it "should be invalid without #{field}" do
      @product_type.send("#{field}=", nil)
      expect(@product_type).to be_invalid
      expect(@product_type.errors[field.to_sym]).not_to be_empty
    end
  end

  it 'should have associated purchase items' do
    expect(@product_type.respond_to?(:purchase_items)).to be_true
  end

  it 'should not be deletable if it has any associated purchase items' do
    purchase_item = Factory :purchase_item
    purchase_item.product_type = @product_type
    purchase_item.save

    expect(purchase_item.product_type).to eq(@product_type)

    product_type_id = @product_type.id
    expect { @product_type.destroy }.to raise_error
    expect(ProductType.find(product_type_id)).not_to be_nil
  end
end
