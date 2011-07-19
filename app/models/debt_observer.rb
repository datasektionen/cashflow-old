class DebtObserver < ActiveRecord::Observer
  def after_create(debt)
    person = debt.author
    debt.logger.info("New debt created by #{person}!")
    Notifier.debt_created(debt, person).deliver
  end

  def after_cancel(debt)
    person = Person.find(debt.versions.last.whodunnit)
    debt.logger.info("Debt cancelled by #{person}!")
    Notifier.debt_cancelled(debt, person).deliver
  end

  def after_pay(debt)
    person = Person.find(debt.versions.last.whodunnit)
    debt.logger.info("Debt paid by #{person}!")
    Notifier.debt_paid(debt, person).deliver
  end
end
