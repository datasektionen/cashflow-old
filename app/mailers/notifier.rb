class Notifier < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: 'noreply@d.ths.kth.se'
  default cc: 'kassor@d.kth.se'
  default_url_options[:host] = Cashflow::Application.settings['default_host']

  %w[purchase_created purchase_approved purchase_denied].each do |name|
    define_method name do |purchase|
      @purchase = purchase
      @administrator = purchase.last_updated_by
      mail(mail_header_params(purchase, name))
    end
  end

  def purchase_paid(purchase)
    @purchase = purchase
    @administrator = purchase.last_updated_by
    options = mail_header_params(purchase, 'purchase_paid')
    options.store(:cc, purchase.business_unit.email || @administrator.email)
    mail(options)
  end

  define_debt_email = ->(name, admin_method) {
    define_method name do |debt|
      @debt = debt
      @administrator = debt.send(admin_method)
      mail(mail_header_params(debt, name))
    end
  }

  define_debt_email["debt_created", :author]
  define_debt_email["debt_paid", :last_updated_by]
  define_debt_email["debt_cancelled", :last_updated_by]

  private

  def mail_header_params(source, subject)
    {
      to: source.person.email,
      subject: I18n.t("mailers.notifier.#{subject}"),
      cc: source.last_updated_by.email,
      reply_to: source.last_updated_by.email
    }
  end
end
