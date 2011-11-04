require "spec_helper"
describe Mage::Voucher do
  it "should have proper voucher_rows functionality" do
    v = Mage::Voucher.new
    v.accounting_date = "2011-11-11"
    v.voucher_rows.should == []
    v.voucher_rows << Mage::VoucherRow.new(:sum=>200,:account_number=>1921)
    v.voucher_rows.count.should == 1
    v.voucher_rows[0].sum.should == 200
    v.voucher_rows[0].account_number.should == 1921
    v.attributes[:voucher_rows_attributes][0][:sum].should == 200
    v.attributes[:voucher_rows_attributes][0][:account_number].should == 1921
    v.attributes[:voucher_rows].should == nil
    v.accounting_date.should == "2011-11-11"
  end

  it "should convert purchase into voucher correctly" do
    person = Factory :person
    PaperTrail.whodunnit = person.id.to_s
    p = Factory :purchase, workflow_state: :paid
    pi = Factory.build(:purchase_item)
    pi.purchase = p
    pi.save

    v = Mage::Voucher.from_purchase(p,"M")
    v.accounting_date.should == p.purchased_at
    v.authorized_by.should == p.confirmed_by.ugid
    v.material_from.should == p.person.ugid
    v.organ.should == p.budget_post.business_unit.mage_number
    v.title.should == p.description
  end
end
