require 'spec_helper'

describe BusinessUnitsController do
  def mock_business_unit(stubs = {})
    (@mock_business_unit ||= mock_model(BusinessUnit).as_null_object).tap do |business_unit|
      business_unit.stub(stubs) unless stubs.empty?
    end
  end

  deny_access_for_ordinary_user

  describe 'logged in as accountant accountant' do
    login_accountant

    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @ability.can :read, :all
      @controller.stub(:current_ability).and_return(@ability)
    end

    describe 'GET index' do
      it 'assigns all business_units as @business_units' do
        BusinessUnit.stub(:all).and_return { [mock_business_unit] }
        get :index
        assigns(:business_units).should eq([mock_business_unit])
      end
    end

    describe 'GET show' do
      it 'assigns the requested business_unit as @business_unit' do
        BusinessUnit.stub(:find).with('37') { mock_business_unit }
        get :show, id: '37'
        assigns(:business_unit).should be(mock_business_unit)
      end
    end
  end

  describe 'valid business unit editor' do
    login_admin

    describe 'GET index' do
      it 'assigns all business_units as @business_units' do
        BusinessUnit.stub(:all) { [mock_business_unit] }
        get :index
        assigns(:business_units).should eq([mock_business_unit])
      end
    end

    describe 'GET show' do
      it 'assigns the requested business_unit as @business_unit' do
        BusinessUnit.stub(:find).with('37') { mock_business_unit }
        get :show, id: '37'
        assigns(:business_unit).should be(mock_business_unit)
      end
    end

    describe 'GET new' do
      it 'assigns a new business_unit as @business_unit' do
        BusinessUnit.stub(:new) { mock_business_unit }
        get :new
        assigns(:business_unit).should be(mock_business_unit)
      end
    end

    describe 'GET edit' do
      it 'assigns the requested business_unit as @business_unit' do
        BusinessUnit.stub(:find).with('37') { mock_business_unit }
        get :edit, id: '37'
        assigns(:business_unit).should be(mock_business_unit)
      end
    end

    describe 'POST create' do
      describe 'with valid params' do
        it 'assigns a newly created business_unit as @business_unit' do
          BusinessUnit.stub(:new).with('these' => 'params') { mock_business_unit(save: true) }
          post :create, business_unit: { 'these' => 'params' }
          assigns(:business_unit).should be(mock_business_unit)
        end

        it 'redirects to the created business_unit' do
          BusinessUnit.stub(:new) { mock_business_unit(save: true) }
          post :create, business_unit: {}
          response.should redirect_to(business_unit_url(mock_business_unit))
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved business_unit as @business_unit' do
          BusinessUnit.stub(:new).with('these' => 'params') { mock_business_unit(save: false) }
          post :create, business_unit: { 'these' => 'params' }
          assigns(:business_unit).should be(mock_business_unit)
        end

        it "re-renders the 'new' template" do
          BusinessUnit.stub(:new) { mock_business_unit(save: false) }
          post :create, business_unit: {}
          response.should render_template('new')
        end
      end
    end

    describe 'PUT update' do
      describe 'with valid params' do
        it 'updates the requested business_unit' do
          BusinessUnit.should_receive(:find).with('37') { mock_business_unit }
          mock_business_unit.should_receive(:update_attributes).with('these' => 'params')
          put :update, id: '37', business_unit: { 'these' => 'params' }
        end

        it 'assigns the requested business_unit as @business_unit' do
          BusinessUnit.stub(:find) { mock_business_unit(update_attributes: true) }
          put :update, id: '1'
          assigns(:business_unit).should be(mock_business_unit)
        end

        it 'redirects to the business_unit' do
          BusinessUnit.stub(:find) { mock_business_unit(update_attributes: true) }
          put :update, id: '1'
          response.should redirect_to(business_unit_url(mock_business_unit))
        end
      end

      describe 'with invalid params' do
        it 'assigns the business_unit as @business_unit' do
          BusinessUnit.stub(:find) { mock_business_unit(update_attributes: false) }
          put :update, id: '1'
          assigns(:business_unit).should be(mock_business_unit)
        end

        it "re-renders the 'edit' template" do
          BusinessUnit.stub(:find) { mock_business_unit(update_attributes: false) }
          put :update, id: '1'
          response.should render_template('edit')
        end
      end
    end

    describe 'DELETE destroy' do
      it 'destroys the requested business_unit' do
        BusinessUnit.should_receive(:find).with('37') { mock_business_unit }
        mock_business_unit.should_receive(:destroy)
        delete :destroy, id: '37'
      end

      it 'redirects to the business_units list' do
        BusinessUnit.stub(:find) { mock_business_unit }
        delete :destroy, id: '1'
        response.should redirect_to(business_units_url)
      end
    end
  end
end
