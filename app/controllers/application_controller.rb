class ApplicationController < ActionController::Base
  before_filter :cas_filter
  before_filter :current_user
  protect_from_forgery
  layout 'application'
  
  private
  def cas_filter
    CASClient::Frameworks::Rails::Filter.filter(self)
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = PersonSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.person
  end
  
end
