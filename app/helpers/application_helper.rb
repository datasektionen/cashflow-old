module ApplicationHelper
  def logged_in?
    session[:cas_user]
  end
end
