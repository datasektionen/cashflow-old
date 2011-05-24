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

  def deny_access_for_ordinary_user
    describe "logged in as ordinary user" do
      login_user
      render_views

      (%w[index show new edit].map{|x|"GET #{x}"}|["POST create", "PUT update", "DELETE destroy"]).each do |page|
        describe page do
          it "should render 'access denied'" do
            get :index
            response.status.should == 403
            response.body.should include("Åtkomst nekad")
          end
        end
      end
    end
  end
end
