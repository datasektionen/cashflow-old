module ApplicationHelper
  def logged_in?
    session[:cas_user]
  end
  
  def session_change_link
    if logged_in?
      link_to "Logga ut", logout_path,:class => "session-change"
    else
      link_to "Logga in", login_path, :class => "session-change"
    end
  end
  
  def currency(amount)
    number_to_currency(amount)
    # ("%0.2f" % amount.to_f).gsub('.',',')
  end
  
  def status(model)
    I18n.t model.workflow_state, :scope => [:workflow_state]
  end
  
  def short_time(date_or_time)
    I18n.l date_or_time, :format => :short
  end
end
