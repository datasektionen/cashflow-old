require 'spec_helper'

describe DebtsController do
  # render_views
  login_admin

  def mock_debt(stubs={})
    (@mock_debt ||= mock_model(Debt).as_null_object).tap do |debt|
      debt.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all debts as @debts" do
      debts = Debt.all
      get :index
      assigns(:debts).should eq debts
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
    xit "assigns a new debt as @debt" do
      Debt.stub(:new) { mock_debt }
      get :new
      assigns(:debt).should be(mock_debt)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created debt as @debt" do
        debt = Factory.build(:debt)
        post :create, :debt => debt.attributes
        
        assigns(:debt).should == Debt.last
      end

      it "redirects to the created debt" do
        debt = Factory.build(:debt)
        post :create, :debt => debt.attributes
        response.should redirect_to(debt_url(Debt.last))
      end
    end

    describe "with invalid params" do
      xit "assigns a newly created but unsaved debt as @debt" do
        debt = Factory.build :invalid_debt
        post :create, :debt => debt.attributes
        debugger
        assigns(:debt).should be debt
      end

      xit "re-renders the 'new' template" do
        Debt.stub(:new) { mock_debt(:save => false) }
        post :create, :debt => {}
        response.should render_template("new")
      end
    end
  end
end
