class PurchaseObserver < ActiveRecord::Observer
  def after_create(purchase)
    Notifier.purchase_created(purchase).deliver
  end

  def after_keep(purchase)
    voucher = Mage::Voucher.from_purchase(purchase)
    unless voucher.push(purchase.last_updated_by)
      fail "An error occured when pushing #{purchase.inspect} to MAGE (push returned false)"
    end
  end
end
