class Notifier < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default :from => "noreply@d.ths.kth.se"
  default_url_options[:host] = Cashflow::Application.settings["default_host"]

  def purchase_created(purchase)
    @purchase = purchase
    @administrator = purchase.updated_by
    mail(:to => @purchase.person.email, 
         :subject => "Inköp registrerat", 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def purchase_approved(purchase)
    @purchase = purchase
    @administrator = purchase.updated_by
    mail(:to => @purchase.person.email, 
         :subject => "Inköp godkänt", 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def purchase_denied(purchase)
    @purchase = purchase
    @administrator = purchase.updated_by
    mail(:to => @purchase.person.email, 
         :subject => "Inköp avslaget", 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def purchase_paid(purchase)
    @purchase = purchase
    @administrator = purchase.updated_by
    mail(:to => @purchase.person.email, 
         :subject => "Inköp utbetalat", 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def debt_created(debt)
    @debt = debt
    @administrator = debt.author
    mail(:to => @debt.person.email, 
         :subject => "Skuld inlagd", 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def debt_paid(debt)
    @debt = debt
    @administrator = Person.find(debt.versions.last.whodunnit)
    mail(:to => @debt.person.email, 
         :subject => "Skuld betalad", 
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end

  def debt_cancelled(debt)
    @debt = debt
    @administrator = Person.find(debt.versions.last.whodunnit)
    mail(:to => @debt.person.email,
         :subject => "Skuld struken",
         :cc => @administrator.email,
         :reply_to => @administrator.email
        ) do |format|
      format.text
    end
  end
end

