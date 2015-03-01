require "spec_helper"

RSpec.describe ProductType do
  subject { create(:product_type) }

  %w(name description).each do |field|
    it "should be invalid without #{field}" do
      subject.send("#{field}=", nil)
      expect(subject).to be_invalid
      expect(subject.errors[field.to_sym]).not_to be_empty
    end
  end

  it "should have associated purchase items" do
    expect(subject.respond_to?(:purchase_items)).to be_truthy
  end

  it "should not be deletable if it has any associated purchase items" do
    purchase_item = create(:purchase_item)
    purchase_item.product_type = subject
    purchase_item.save

    expect(purchase_item.product_type).to eq(subject)

    product_type_id = subject.id
    expect { subject.destroy }.to raise_error
    expect(ProductType.find(product_type_id)).not_to be_nil
  end
end
