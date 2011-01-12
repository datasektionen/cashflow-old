class Notifier < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default :from => "noreply@d.ths.kth.se"
  default_url_options[:host] = Cashflow::Appliation.settings["default_host"]

  def purchase_approved(purchase, administrator)
    @purchase = purchase
    @administrator = administrator
    mail(:to => @purchase.person.email, 
         :subject => "Inköp godkänt", 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def purchase_denied(purchase, administrator)
    @purchase = purchase
    @administrator = administrator
    mail(:to => @purchase.person.email, 
         :subject => "Inköp avslaget", 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def purchase_paid(purchase, administrator)
    @purchase = purchase
    @administrator = administrator
    mail(:to => @purchase.person.email, 
         :subject => "Inköp utbetalat", 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def debt_created(debt, administrator)
    @debt = debt
    @administrator = administrator
    mail(:to => @debt.person.email, 
         :subject => "Skuld inlagd", 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def debt_paid(debt, administrator)
    @debt = debt
    @administrator = administrator
    mail(:to => @debt.person.email, 
         :subject => "Skuld betalad", 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end
end

