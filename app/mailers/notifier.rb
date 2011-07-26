class Notifier < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default :from => "noreply@d.ths.kth.se"
  default :cc => "kassor@d.kth.se"
  default_url_options[:host] = Cashflow::Application.settings["default_host"]

  def purchase_created(purchase)
    @purchase = purchase
    @administrator = purchase.updated_by
    options = {
      :to => @purchase.person.email,
      :subject => "Inköp registrerat",
      :reply_to => @administrator.email
    }
    options.merge!(:cc => purchase.business_unit.email) if purchase.business_unit.try(:email)
    mail(options) do |format|
      format.text
    end
  end

  def purchase_approved(purchase)
    @purchase = purchase
    @administrator = purchase.updated_by
    options = {
      :to => @purchase.person.email,
      :subject => "Inköp godkänt",
      :reply_to => @administrator.email
    }
    options.merge!(:cc => purchase.business_unit.email) if purchase.business_unit.try(:email)
    mail(options) do |format|
      format.text
    end
  end

  def purchase_denied(purchase)
    @purchase = purchase
    @administrator = purchase.updated_by
    options = {
      :to => @purchase.person.email,
      :subject => "Inköp avslaget",
      :reply_to => @administrator.email
    }
    options.merge!(:cc => purchase.business_unit.email) if purchase.business_unit.try(:email)
    mail(options) do |format|
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
    @administrator = debt.author
    options = {
      :to => @purchase.person.email,
      :subject => "Skuld inlagd",
      :reply_to => @administrator.email
    }
    options.merge!(:cc => purchase.business_unit.email) if purchase.business_unit.try(:email)
    mail(options) do |format|
      format.text
    end
  end

  def debt_paid(debt)
    @debt = debt
    @administrator = Person.find(debt.versions.last.whodunnit)
    options = {
      :to => @purchase.person.email,
      :subject => "Skuld betald",
      :reply_to => @administrator.email
    }
    options.merge!(:cc => purchase.business_unit.email) if purchase.business_unit.try(:email)
    mail(options) do |format|
      format.text
    end
  end

  def debt_cancelled(debt)
    @debt = debt
    @administrator = Person.find(debt.versions.last.whodunnit)
    options = {
      :to => @purchase.person.email,
      :subject => "Skuld struken",
      :reply_to => @administrator.email
    }
    options.merge!(:cc => purchase.business_unit.email) if purchase.business_unit.try(:email)
    mail(options) do |format|
      format.text
    end
  end
end

