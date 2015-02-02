require "spec_helper"

describe PurchaseItem do
  subject { create(:purchase_item) }

  %w(purchase product_type).each do |relation|
    it "should belong to a #{relation}" do
      subject.should belong_to(relation.to_sym)
    end
  end

  %w(amount).each do |attr|
    it "should be invalid without a value for #{attr}" do
      subject.send("#{attr}=", nil)
      subject.should be_invalid
      subject.errors[attr.to_sym].should_not be_empty
    end
  end
end
