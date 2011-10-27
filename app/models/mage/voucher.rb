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
end
