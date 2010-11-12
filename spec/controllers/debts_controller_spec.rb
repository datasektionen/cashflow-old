require 'spec_helper'

describe DebtsController do

  def mock_debt(stubs={})
    (@mock_debt ||= mock_model(Debt).as_null_object).tap do |debt|
      debt.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all debts as @debts" do
      Debt.stub(:all) { [mock_debt] }
      get :index
      assigns(:debts).should eq([mock_debt])
    end
  end

  describe "GET show" do
    it "assigns the requested debt as @debt" do
      Debt.stub(:find).with("37") { mock_debt }
      get :show, :id => "37"
      assigns(:debt).should be(mock_debt)
    end
  end

  describe "GET new" do
    it "assigns a new debt as @debt" do
      Debt.stub(:new) { mock_debt }
      get :new
      assigns(:debt).should be(mock_debt)
    end
  end

  describe "GET edit" do
    it "assigns the requested debt as @debt" do
      Debt.stub(:find).with("37") { mock_debt }
      get :edit, :id => "37"
      assigns(:debt).should be(mock_debt)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created debt as @debt" do
        Debt.stub(:new).with({'these' => 'params'}) { mock_debt(:save => true) }
        post :create, :debt => {'these' => 'params'}
        assigns(:debt).should be(mock_debt)
      end

      it "redirects to the created debt" do
        Debt.stub(:new) { mock_debt(:save => true) }
        post :create, :debt => {}
        response.should redirect_to(debt_url(mock_debt))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved debt as @debt" do
        Debt.stub(:new).with({'these' => 'params'}) { mock_debt(:save => false) }
        post :create, :debt => {'these' => 'params'}
        assigns(:debt).should be(mock_debt)
      end

      it "re-renders the 'new' template" do
        Debt.stub(:new) { mock_debt(:save => false) }
        post :create, :debt => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested debt" do
        Debt.should_receive(:find).with("37") { mock_debt }
        mock_debt.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :debt => {'these' => 'params'}
      end

      it "assigns the requested debt as @debt" do
        Debt.stub(:find) { mock_debt(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:debt).should be(mock_debt)
      end

      it "redirects to the debt" do
        Debt.stub(:find) { mock_debt(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(debt_url(mock_debt))
      end
    end

    describe "with invalid params" do
      it "assigns the debt as @debt" do
        Debt.stub(:find) { mock_debt(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:debt).should be(mock_debt)
      end

      it "re-renders the 'edit' template" do
        Debt.stub(:find) { mock_debt(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested debt" do
      Debt.should_receive(:find).with("37") { mock_debt }
      mock_debt.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the debts list" do
      Debt.stub(:find) { mock_debt }
      delete :destroy, :id => "1"
      response.should redirect_to(debts_url)
    end
  end

end
