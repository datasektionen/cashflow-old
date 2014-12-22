require 'mage/base'
require 'mage/mapper'
require 'mage/voucher_row'

class Mage::Voucher < Mage::Base
  create_action :api_create
  before_initialize :create_voucher_rows

  def attributes
    attr = super.clone
    attr.delete(:voucher_rows)
    attr[:voucher_rows_attributes] = @attr[:voucher_rows].map(&:attributes)
    attr
  end

  def create_voucher_rows
    self.voucher_rows = []
  end

  ##
  # Creates a vouchers from a given purchase in the series specified
  def self.from_purchase(purchase)
    mapper = Mage::Mapper.instance

    if purchase.keepable?
      voucher = Mage::Voucher.new
      voucher.series = mapper.series!(purchase.business_unit)
      voucher.activity_year = purchase.year
      voucher.authorized_by = purchase.confirmed_by.ugid
      voucher.material_from = purchase.person.ugid
      voucher.organ = mapper.organ_number!(purchase.business_unit)
      voucher.title = "#{purchase.slug.upcase} - #{purchase.description}"
      voucher.accounting_date = purchase.purchased_on
      total_sum = 0
      purchase.items.each do |i|
        total_sum += i.amount
        vr = Mage::VoucherRow.new
        vr.sum = i.amount
        vr.account_number = mapper.account_number!(i.product_type)
        vr.arrangement = mapper.arrangement_number!(purchase.budget_post)
        if vr.arrangement.nil?
          fail "Arrangement for purchase #{purchase.id}, budget_post #{purchase.budget_post} is nil"
        end
        if vr.account_number.nil?
          fail "AccountNumber for product type #{i.product_type.name} is nil"
        end
        voucher.voucher_rows << vr
      end
      voucher.voucher_rows << Mage::VoucherRow.new(sum: -total_sum, account_number: 2820)
      voucher
    end
  end
end
