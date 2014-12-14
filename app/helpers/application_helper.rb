module ApplicationHelper
  def logged_in?
    session[:cas_user]
  end

  def session_change_link
    if user_signed_in?
      link_to 'Logga ut', destroy_user_session_path, class: 'session-change'
    else
      link_to 'Logga in', new_session_path, class: 'session-change'
    end
  end

  def status(model)
    I18n.t model.workflow_state, scope: [:workflow_state]
  end
end
