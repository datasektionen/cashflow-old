class ApplicationController < ActionController::Base
  layout 'application'

  protect_from_forgery

  before_filter :authenticate_user!

  ##
  # Display a 403 error and an access denied page if the current user doesn't have proper access rights
  rescue_from CanCan::AccessDenied do |_exception|
    render file: "#{Rails.root}/public/403", formats: [:html], status: 403
  end
end
