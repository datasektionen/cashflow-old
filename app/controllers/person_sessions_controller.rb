class PersonSessionsController < ApplicationController
  skip_before_filter :cas_filter, :only => :destroy #CASClient::Frameworks::Rails::Filter
  layout 'application'
  
  def new
    unless Person.exists?(:ugid => session[:cas_user])
      Person.create_from_ldap(:ugid => session[:cas_user])
    end
    redirect_to root_path
  end
    
  def destroy
    reset_session
    render 'logout'
    # CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
