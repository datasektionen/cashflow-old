module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      @current_person = Factory :admin
      sign_in @current_person
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @current_person = Factory :person
      sign_in @current_person
    end
  end

  def login_treasurer
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:treasurer]
      @current_person = Factory :person
      sign_in @current_person
    end
  end

  def login_accountant
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:accountant]
      @current_person = Factory :person
      sign_in @current_person
    end
  end
end
