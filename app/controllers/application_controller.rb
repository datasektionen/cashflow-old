class ApplicationController < ActionController::Base
  layout 'application'

  protect_from_forgery
  has_mobile_fu
  
  before_filter :cas_filter
  before_filter :current_user
  
  helper_method :current_user

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

  def current_ability
    Ability.new(current_user)
  end

  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403.html", :status => 403
  end
  
end
