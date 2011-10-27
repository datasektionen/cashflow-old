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
end
