require "spec_helper"

RSpec.describe PurchaseItem do
  subject { create(:purchase_item) }

  %w(purchase product_type).each do |relation|
    it "should belong to a #{relation}" do
      expect(subject).to belong_to(relation.to_sym)
    end
  end

  %w(amount).each do |attr|
    it "should be invalid without a value for #{attr}" do
      subject.send("#{attr}=", nil)
      expect(subject).to be_invalid
      expect(subject.errors[attr.to_sym]).not_to be_empty
    end
  end
end
