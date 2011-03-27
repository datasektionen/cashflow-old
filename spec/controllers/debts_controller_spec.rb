require 'spec_helper'

describe DebtsController do
  render_views
  login_admin

  def mock_debt(stubs={})
    (@mock_debt ||= mock_model(Debt).as_null_object).tap do |debt|
      debt.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all debts as @debts" do
      Debt.stub!(:all) { [mock_debt] }
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
end
