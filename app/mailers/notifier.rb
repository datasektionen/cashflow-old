class Notifier < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default :from => "noreply@d.ths.kth.se"
  default :cc => "kassor@d.kth.se"
  default_url_options[:host] = Cashflow::Application.settings["default_host"]

  def purchase_created(purchase)
    @purchase = purchase
    @administrator = administrator
    mail(:to => @purchase.person.email, 
         :subject => I18n.t('mailers.notifier.purchase_approved'), 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def purchase_approved(purchase)
    @purchase = purchase
    @administrator = administrator
    mail(:to => @purchase.person.email, 
         :subject => I18n.t('mailers.notifier.purchase_denied'), 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def purchase_denied(purchase)
    @purchase = purchase
    @administrator = administrator
    mail(:to => @purchase.person.email, 
         :subject => I18n.t('mailers.notifier.purchase_paid'), 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def purchase_paid(purchase)
    @purchase = purchase
    @administrator = purchase.updated_by
    options = {
      :to => @purchase.person.email,
      :subject => "Inköp utbetalt",
      :reply_to => @administrator.email
    }
    options.merge!(:cc => purchase.business_unit.email) if purchase.business_unit.try(:email)
    mail(options) do |format|
      format.text
    end
  end

  def debt_created(debt)
    @debt = debt
    @administrator = administrator
    mail(:to => @debt.person.email, 
         :subject => I18n.t('mailers.notifier.debt_created'), 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def debt_paid(debt)
    @debt = debt
    @administrator = administrator
    mail(:to => @debt.person.email, 
         :subject => I18n.t('mailers.notifier.debt_paid'), 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def debt_cancelled(debt)
    @debt = debt
    @administrator = administrator
    mail(:to => @debt.person.email,
         :subject => I18n.t('mailers.notifier.debt_paid'),
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end
end

