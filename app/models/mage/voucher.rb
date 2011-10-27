class Mage::Voucher < Mage::Base
  create_action :api_create

  def voucher_rows 
    @voucher_rows = [] unless @voucher_rows
  end

  def voucher_rows=(vr)
    @voucher_rows = vr
  end

  def voucher_rows?
    return !@voucher_rows.empty?
  end

  def attributes
    attr = super
    attr[:voucher_rows_attributes] = @voucher_rows.map { |vr| vr.attributes }
  end
end
