require "spec_helper"

describe ProductType do
  subject { create(:product_type) }

  %w(name description).each do |field|
    it "should be invalid without #{field}" do
      subject.send("#{field}=", nil)
      subject.should be_invalid
      subject.errors[field.to_sym].should_not be_empty
    end
  end

  it "should have associated purchase items" do
    subject.respond_to?(:purchase_items).should be_true
  end

  it "should not be deletable if it has any associated purchase items" do
    purchase_item = create(:purchase_item)
    purchase_item.product_type = subject
    purchase_item.save

    purchase_item.product_type.should == (subject)

    product_type_id = subject.id
    lambda { subject.destroy }.should raise_error
    ProductType.find(product_type_id).should_not be_nil
  end
end
