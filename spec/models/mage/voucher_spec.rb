require 'spec_helper'
describe Mage::Voucher do
  before(:each) do
    stub_request(:post, 'http://localhost:8981/solr/update?wt=ruby').to_return(status: 200, body: '')
  end

  it 'should have proper voucher_rows functionality' do
    v = Mage::Voucher.new
    v.accounting_date = '2011-11-11'
    expect(v.voucher_rows).to eq([])
    v.voucher_rows << Mage::VoucherRow.new(sum: 200, account_number: 1921)
    expect(v.voucher_rows.count).to eq(1)
    expect(v.voucher_rows[0].sum).to eq(200)
    expect(v.voucher_rows[0].account_number).to eq(1921)
    expect(v.attributes[:voucher_rows_attributes][0][:sum]).to eq(200)
    expect(v.attributes[:voucher_rows_attributes][0][:account_number]).to eq(1921)
    expect(v.attributes[:voucher_rows]).to.nil?
    expect(v.accounting_date).to eq('2011-11-11')
  end

  it 'should convert purchase into voucher correctly', versioning: true do
    person = Factory :person
    PaperTrail.whodunnit = person.id.to_s
    purchase = Factory :purchase
    purchase_item = Factory.build(:purchase_item)
    purchase_item.purchase = purchase
    purchase_item.save
    purchase.confirm!

    voucher = Mage::Voucher.from_purchase(purchase, 'M')
    expect(voucher.accounting_date).to eq(purchase.purchased_on)
    expect(voucher.authorized_by).to eq(purchase.confirmed_by.ugid)
    expect(voucher.material_from).to eq(purchase.person.ugid)
    expect(voucher.organ).to eq(purchase.budget_post.business_unit.mage_number)
    expect(voucher.title).to eq("#{purchase.slug.upcase} - #{purchase.description}")
  end
end
