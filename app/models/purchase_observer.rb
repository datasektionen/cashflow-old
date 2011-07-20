class PurchaseObserver < ActiveRecord::Observer
  def after_create(purchase)
    person = purchase.updated_by
    purchase.logger.info("New purchase created by #{person}!")
    Notifier.purchase_created(purchase, person).deliver
  end

  def after_confirm(purchase)
    person = purchase.updated_by
    purchase.logger.info("Purchase confirmed by #{person}!")
    Notifier.purchase_approved(purchase, person).deliver
  end

  def after_pay(purchase)
    person = purchase.updated_by
    purchase.logger.info("Purchase paid by #{person}!")
    Notifier.purchase_paid(purchase, person).deliver
  end

  def after_cancel(purchase)
    person = purchase.updated_by
    purchase.logger.info("Purchase cancelled by #{person}!")
    Notifier.purchase_denied(purchase, person).deliver
  end
end
