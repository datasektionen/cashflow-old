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
  # @param series_letter The letter for the series to put the voucher in
  def self.from_purchase(purchase, series_letter = nil)
    if series_letter.nil?
      # Fetch series letter from purchase if nil
      series_letter = purchase.business_unit.mage_default_series
    end

    if purchase.keepable?

      if series_letter.nil?
        fail 'BusinessUnit lacks default MAGE series'
      end

      voucher = Mage::Voucher.new
      voucher.series = series_letter
      voucher.activity_year = purchase.year
      voucher.authorized_by = purchase.confirmed_by.ugid
      voucher.material_from = purchase.person.ugid
      voucher.organ = purchase.budget_post.business_unit.mage_number
      voucher.title = "#{purchase.slug.upcase} - #{purchase.description}"
      voucher.accounting_date = purchase.purchased_on
      total_sum = 0
      purchase.items.each do |i|
        total_sum += i.amount
        vr = Mage::VoucherRow.new
        vr.sum = i.amount
        vr.account_number = i.product_type.mage_account_number
        vr.arrangement = purchase.budget_post.mage_arrangement_number
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
