class ApplicationController < ActionController::Base
  layout 'application'

  protect_from_forgery
  has_mobile_fu
  
  before_filter :authenticate_person!
  private
  def current_user
    current_person
  end

  ##
  # Display a 403 error and an access denied page if the current user doesn't have proper access rights
  rescue_from CanCan::Unauthorized do |exception|
    render :file => "#{Rails.root}/public/403.html", :status => 403
  end
end
