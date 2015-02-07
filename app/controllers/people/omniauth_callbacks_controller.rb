class People::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :authorize_user!
  skip_authorization_check

  before_filter :load_person, only: [:cas, :developer]

  def new
    redirect_to user_omniauth_authorize_path(:cas)
  end

  def cas
    sign_in_if_persisted("CAS")
  end

  def developer
    unless Cashflow::Application.settings["enable_developer_login_strategy"]
      render text: "Permission denied", status: :forbidden
      return
    end

    sign_in_if_persisted("Developer")
  end

  def destroy
    sign_out_and_redirect current_user
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || person_path(current_user)
  end

  private

  def load_person
    @person = Person.find_for_oauth(env["omniauth.auth"], current_user)
  end

  def sign_in_if_persisted(kind)
    if @person.persisted?
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: kind)
      sign_in_and_redirect @person, event: :authentication
    else
      redirect_to root_url
    end
  end
end
