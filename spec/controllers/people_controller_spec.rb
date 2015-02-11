require "spec_helper"

describe PeopleController do
  let(:default_params) { { locale: "sv" } }

  def mock_person(stubs = {})
    stubs = stubs.reverse_merge(to_str: nil)
    @mock_person ||= mock_model(Person, stubs).as_null_object
  end

  describe "unauthenticated user" do
    it "should be redirected to the login page" do
      get :index
      expect(response).to redirect_to(root_url)
    end
  end

  describe "authenticated user" do
    login_admin

    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @ability.can :access, :all
      @ability.can :manage, :all
    end

    describe "GET index" do
      it "assigns all people as @people" do
        get :index
        expect(assigns(:people)).to eq(Person.all)
      end
    end

    describe "GET show" do
      # render_views
      it "assigns the requested person as @person" do
        allow(Person).to receive(:find).with("37") { mock_person }
        get :show, id: "37"
        expect(assigns(:person)).to be(mock_person)
      end
    end

    describe "GET new" do
      it "assigns a new person as @person" do
        allow(Person).to receive(:new) { mock_person }
        get :new
        expect(assigns(:person)).to be(mock_person)
      end
    end

    describe "GET edit" do
      it "assigns the requested person as @person" do
        allow(Person).to receive(:find).with("37") { mock_person }
        get :edit, id: "37"
        expect(assigns(:person)).to be(mock_person)
      end
    end

    describe "POST create" do
      before(:each) do
        @ability = Object.new
        @ability.extend(CanCan::Ability)
        @ability.can :manage, Person
        allow(@controller).to receive(:current_ability).and_return(@ability)
      end

      describe "with valid params" do
        it "assigns a newly created person as @person" do
          allow(Person).to receive(:new).
                            with("these" => "params").
                            and_return(mock_person(save: true))
          post :create, person: { "these" => "params" }
          expect(assigns(:person)).to be(mock_person)
        end

        # TODO: PeopleController#create does some magic with ldap, since we
        # can't have arbitrary users...  the controller tries to go to
        # /people/some-user-name
        it "redirects to the created person" do
          @ability.can(:manage, :all)
          allow(@controller).to receive(:current_ability).and_return(@ability)
          allow(Person).to receive(:new) { mock_person(save: true) }
          post :create, person: {}
          expect(response).to redirect_to(person_url(mock_person))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved person as @person" do
          allow(Person).to receive(:new).
                            with("these" => "params").
                            and_return(mock_person(save: false))
          post :create, person: { "these" => "params" }
          expect(assigns(:person)).to be(mock_person)
        end

        it "re-renders the 'new' template" do
          allow(Person).to receive(:new) { mock_person(save: false) }
          post :create, person: {}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        before do
          allow(Person).to receive(:find).
                            and_return(mock_person(update_attributes: true))
        end
        it "updates the requested person" do
          expect(mock_person).to receive(:update_attributes).
                                  with("these" => "params")
          put :update, id: "37", person: { "these" => "params" }
        end

        it "assigns the requested person as @person" do
          put :update, id: "1"
          expect(assigns(:person)).to be(mock_person)
        end

        it "redirects to the person" do
          put :update, id: "1"
          expect(response).to redirect_to(person_url(mock_person))
        end
      end

      describe "with invalid params" do
        before do
          allow(Person).to receive(:find).
                            and_return(mock_person(update_attributes: false))
        end

        it "assigns the person as @person" do
          put :update, id: "1"
          expect(assigns(:person)).to be(mock_person)
        end

        it "re-renders the 'edit' template" do
          put :update, id: "1"
          expect(response).to render_template("edit")
        end
      end
    end
  end
end
