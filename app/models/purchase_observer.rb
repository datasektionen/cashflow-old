class PurchaseObserver < ActiveRecord::Observer
  def after_create(purchase)
    Notifier.purchase_created(purchase).deliver
  end

  def after_confirm(purchase)
    Notifier.purchase_approved(purchase).deliver
  end

  def after_keep(purchase)
    #TODO: skapa verifikat i mage
  end

  def after_pay(purchase)
    Notifier.purchase_paid(purchase).deliver
  end

  def after_cancel(purchase)
    Notifier.purchase_denied(purchase).deliver
  end
end
