class DebtObserver < ActiveRecord::Observer
  def after_create(debt)
    Notifier.debt_created(debt).deliver
  end

  def after_cancel(debt)
    Notifier.debt_cancelled(debt).deliver
  end

  def after_pay(debt)
    Notifier.debt_paid(debt).deliver
  end
end
