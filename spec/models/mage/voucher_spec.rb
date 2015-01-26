require "spec_helper"
describe Mage::Voucher do
  before(:each) do
    stub_request(:post, "http://localhost:8981/solr/update?wt=ruby").
      to_return(status: 200, body: "")
  end

  it "should have proper voucher_rows functionality" do
    v = Mage::Voucher.new
    v.accounting_date = "2011-11-11"
    v.voucher_rows.should == []
    v.voucher_rows << Mage::VoucherRow.new(sum: 200, account_number: 1921)
    v.voucher_rows.count.should == 1
    v.voucher_rows[0].sum.should == 200
    v.voucher_rows[0].account_number.should == 1921
    v.attributes[:voucher_rows_attributes][0][:sum].should == 200
    v.attributes[:voucher_rows_attributes][0][:account_number].should == 1921
    v.attributes[:voucher_rows].should.nil?
    v.accounting_date.should == "2011-11-11"
  end

  it "should convert purchase into voucher correctly", versioning: true do
    person = create(:person)
    PaperTrail.whodunnit = person.id.to_s
    purchase = create(:purchase)
    purchase_item = build(:purchase_item)
    purchase_item.purchase = purchase
    purchase_item.save
    purchase.confirm!

    voucher = Mage::Voucher.from_purchase(purchase, "M")
    voucher.accounting_date.should == purchase.purchased_on
    voucher.authorized_by.should == purchase.confirmed_by.ugid
    voucher.material_from.should == purchase.person.ugid
    voucher.organ.should == purchase.budget_post.business_unit.mage_number
    voucher.title.should == "#{purchase.slug.upcase} - #{purchase.description}"
  end
end
