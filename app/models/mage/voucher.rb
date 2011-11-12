class Mage::Voucher < Mage::Base
  create_action :api_create
  before_initialize :create_voucher_rows


  def attributes
    attr = super.clone
    attr.delete(:voucher_rows)
    attr[:voucher_rows_attributes] = @attr[:voucher_rows].map { |vr| vr.attributes }
    attr
  end

  def create_voucher_rows
    self.voucher_rows = [] 
  end

  def self.from_purchase(purchase, series)
    if purchase.keepable?
      voucher = Mage::Voucher.new
      voucher.series = series
      voucher.activity_year = purchase.year
      voucher.authorized_by = purchase.confirmed_by.ugid
      voucher.material_from = purchase.person.ugid
      voucher.organ = purchase.budget_post.business_unit.mage_number
      voucher.title = purchase.description
      voucher.accounting_date = purchase.purchased_at
      total_sum = 0
      purchase.items.each do |i|
        total_sum += i.amount
        vr = Mage::VoucherRow.new
        vr.sum = i.amount
        #vr.comment = i.comment
        vr.account_number = i.product_type.mage_account_number
        vr.arrangement = purchase.budget_post.mage_arrangement_number
        if vr.arrangement.nil?
         raise "Arrangement for purchase #{purchase.id}, budget_post #{purchase.budget_post} is nil"
        end
        voucher.voucher_rows << vr
      end
      voucher.voucher_rows << Mage::VoucherRow.new(:sum=>-total_sum, :account_number=>2820)
      return voucher
    end
  end
end
