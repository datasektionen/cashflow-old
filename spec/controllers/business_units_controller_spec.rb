require "spec_helper"

describe BusinessUnitsController, type: :controller do
  def mock_business_unit(stubs = {})
    @mock_business_unit ||= mock_model(BusinessUnit).as_null_object
    @mock_business_unit.tap do |business_unit|
      stubs = stubs.reverse_merge(to_str: nil)
      stubs.each do |k, v|
        allow(business_unit).to receive(k).and_return(v)
      end
    end
  end

  deny_access_for_ordinary_user
  let(:default_params) { { locale: "sv" } }

  describe "logged in as accountant accountant" do
    login_accountant

    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @ability.can :read, :all
      allow(@controller).to receive(:current_ability).and_return(@ability)
    end

    describe "GET index" do
      it "assigns all business_units as @business_units" do
        allow(BusinessUnit).to receive(:all) { [mock_business_unit] }
        get :index
        expect(assigns(:business_units)).to eq([mock_business_unit])
      end
    end

    describe "GET show" do
      it "assigns the requested business_unit as @business_unit" do
        allow(BusinessUnit).to receive(:find).with("37") { mock_business_unit }
        get :show, id: "37"
        expect(assigns(:business_unit)).to be(mock_business_unit)
      end
    end
  end

  describe "valid business unit editor" do
    login_admin

    describe "GET index" do
      it "assigns all business_units as @business_units" do
        allow(BusinessUnit).to receive(:all) { [mock_business_unit] }
        get :index
        expect(assigns(:business_units)).to eq([mock_business_unit])
      end
    end

    describe "GET show" do
      it "assigns the requested business_unit as @business_unit" do
        allow(BusinessUnit).to receive(:find).with("37") { mock_business_unit }
        get :show, id: "37"
        expect(assigns(:business_unit)).to be(mock_business_unit)
      end
    end

    describe "GET new" do
      it "assigns a new business_unit as @business_unit" do
        allow(BusinessUnit).to receive(:new) { mock_business_unit }
        get :new
        expect(assigns(:business_unit)).to be(mock_business_unit)
      end
    end

    describe "GET edit" do
      it "assigns the requested business_unit as @business_unit" do
        allow(BusinessUnit).to receive(:find).with("37") { mock_business_unit }
        get :edit, id: "37"
        expect(assigns(:business_unit)).to be(mock_business_unit)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "assigns a newly created business_unit as @business_unit" do
          allow(BusinessUnit).to receive(:new).
                                  with("these" => "params").
                                  and_return(mock_business_unit(save: true))
          post :create, business_unit: { "these" => "params" }
          expect(assigns(:business_unit)).to be(mock_business_unit)
        end

        it "redirects to the created business_unit" do
          allow(BusinessUnit).to receive(:new).
                                  and_return(mock_business_unit(save: true))
          post :create, business_unit: {}
          expect(response).to redirect_to(business_unit_url(mock_business_unit))
        end
      end

      describe "with invalid params" do
        it "assigns a new but unsaved business_unit as @business_unit" do
          allow(BusinessUnit).to receive(:new).
                                  with("these" => "params").
                                  and_return(mock_business_unit(save: false))
          post :create, business_unit: { "these" => "params" }
          expect(assigns(:business_unit)).to be(mock_business_unit)
        end

        it "re-renders the 'new' template" do
          allow(BusinessUnit).to receive(:new).
                                  and_return(mock_business_unit(save: false))
          post :create, business_unit: {}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested business_unit" do
          expect(BusinessUnit).to receive(:find).
                                  with("37").
                                  and_return(mock_business_unit)
          expect(mock_business_unit).to receive(:update_attributes).
                                        with("these" => "params")
          put :update, id: "37", business_unit: { "these" => "params" }
        end

        it "assigns the requested business_unit as @business_unit" do
          allow(BusinessUnit).to receive(:find) {
            mock_business_unit(update_attributes: true)
          }
          put :update, id: "1"
          expect(assigns(:business_unit)).to be(mock_business_unit)
        end

        it "redirects to the business_unit" do
          allow(BusinessUnit).to receive(:find) {
            mock_business_unit(update_attributes: true)
          }
          put :update, id: "1"
          expect(response).to redirect_to(business_unit_url(mock_business_unit))
        end
      end

      describe "with invalid params" do
        it "assigns the business_unit as @business_unit" do
          allow(BusinessUnit).to receive(:find).
                        and_return(mock_business_unit(update_attributes: false))
          put :update, id: "1"
          expect(assigns(:business_unit)).to be(mock_business_unit)
        end

        it "re-renders the 'edit' template" do
          allow(BusinessUnit).to receive(:find) {
            mock_business_unit(update_attributes: false)
          }
          put :update, id: "1"
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested business_unit" do
        expect(BusinessUnit).to receive(:find).with("37") { mock_business_unit }
        expect(mock_business_unit).to receive(:destroy)
        delete :destroy, id: "37"
      end

      it "redirects to the business_units list" do
        allow(BusinessUnit).to receive(:find) { mock_business_unit }
        delete :destroy, id: "1"
        expect(response).to redirect_to(business_units_url)
      end
    end
  end
end
