class People::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def new
    redirect_to user_omniauth_authorize_path(:cas)
  end

  def cas
    @person = Person.find_for_cas_oath(env["omniauth.auth"], current_user)
    if @person.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "CAS"
      sign_in_and_redirect @person, :event => :authentication
    else
      redirect_to root_url
    end
  end

  def destroy
    sign_out_and_redirect current_user
  end

  def after_sign_in_path_for(resource)
  	stored_location_for(resource) || person_path(current_user)
  end
end
