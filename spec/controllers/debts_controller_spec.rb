require 'spec_helper'

describe DebtsController do
  # render_views
  login_admin

  def valid_attributes
    { description: 'foo', amount: 100 }
  end

  def mock_debt(stubs = {})
    (@mock_debt ||= mock_model(Debt).as_null_object).tap do |debt|
      debt.stub(stubs) unless stubs.empty?
    end
  end

  describe 'GET index' do
    it 'assigns all debts as @debts' do
      debts = [mock_debt, mock_debt]
      Debt.stub(:accessible_by).and_return(debts)

      get :index
      assigns(:debts).should == debts
    end
  end

  describe 'GET show' do
    it 'assigns the requested debt as @debt' do
      Debt.stub(:find).with('37') { mock_debt }
      get :show, id: '37'
      assigns(:debt).should be(mock_debt)
    end
  end

  describe 'GET new' do
    it 'assigns a new debt as @debt' do
      Debt.stub(:new) { mock_debt }
      get :new
      assigns(:debt).should be(mock_debt)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'assigns a newly created debt as @debt' do
        debt = mock_debt
        Debt.stub(:new).and_return(debt)
        debt.stub(:save).and_return(true)

        post :create, debt: debt.attributes
        assigns(:debt).should == debt
      end

      it 'redirects to the created debt' do
        debt = mock_debt
        Debt.stub(:new).and_return(debt)
        debt.stub(:save).and_return(true)

        post :create, debt: debt.attributes
        response.should redirect_to(debt_url(debt))
      end
    end

    describe 'with invalid params' do
      it "re-renders the 'new' template" do
        Debt.stub(:new) { mock_debt(save: false) }
        post :create, debt: {}
        response.should render_template('new')
      end
    end
  end
end
