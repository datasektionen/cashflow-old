module ControllerMacros
  def login_admin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      @current_user = Factory :admin
      sign_in @current_user
    end
  end

  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @current_user = Factory :person
      sign_in @current_user
    end
  end

  def login_treasurer
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:treasurer]
      @current_user = Factory :person
      sign_in @current_user
    end
  end

  def login_accountant
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:accountant]
      @current_user = Factory :person
      sign_in @current_user
    end
  end

  # TODO: extract the access_denied string test to a view spec.
  def deny_access_for_ordinary_user
    describe 'logged in as ordinary user' do
      login_user
      render_views

      (%w(index show new edit).map { |x|"GET #{x}" } | ['POST create', 'PUT update', 'DELETE destroy']).each do |page|
        describe page do
          it "should render 'access denied'" do
            get :index
            expect(response.status).to eq(403)
            expect(response.body).to include(I18n.t('access_denied'))
          end
        end
      end
    end
  end
end
