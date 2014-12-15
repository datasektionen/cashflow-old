require 'spec_helper'

describe BudgetRowsController do
  login_admin

  before(:all) do
    @year = Time.now.year.to_s
  end

  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @ability.can :access, :all
    @ability.can :manage, :all
  end

  def valid_attributes
    { sum: 1000, year: @year }
  end

  def mock_budget_row(extra_attributes = {})
    double('budget_row', valid_attributes.merge(extra_attributes))
  end

  describe 'GET index' do
    it 'assigns all budget_rows as @budget_rows' do
      budget_row = mock_budget_row
      BudgetRow.stub(:year).with(@year).and_return([budget_row])
      get :index, budget_id: @year
      assigns(:budget_rows).should == [budget_row]
    end
  end

  describe 'GET show' do
    it 'assigns the requested budget_row as @budget_row' do
      budget_row = mock_budget_row(id: '17', budget_post: double('budget_post', name: 'post'))
      BudgetRow.stub(:find).with(budget_row.id).and_return(budget_row)

      get :show, budget_id: @year, id: budget_row.id
      assigns(:budget_row).should eq(budget_row)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested budget_row as @budget_row' do
      budget_row = mock_budget_row(id: '17', budget_post: double('budget_post', name: 'post'))
      BudgetRow.stub(:find).with(budget_row.id).and_return(budget_row)

      get :edit, id: budget_row.id, budget_id: @year
      assigns(:budget_row).should eq(budget_row)
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested budget_row' do
        budget_row = mock_budget_row(id: '17', budget_post: double('budget_post', name: 'post'))
        BudgetRow.stub(:find).with(budget_row.id).and_return(budget_row)
        budget_row.should_receive(:update_attributes).with('these' => 'params')

        put :update, budget_id: @year, id: budget_row.id, budget_row: { 'these' => 'params' }
      end

      it 'assigns the requested budget_row as @budget_row' do
        budget_row = mock_budget_row(id: '17', budget_post: double('budget_post', name: 'post'))
        BudgetRow.stub(:find).with(budget_row.id).and_return(budget_row)
        budget_row.stub(:update_attributes)

        put :update, budget_id: @year, id: budget_row.id, budget_row: valid_attributes
        assigns(:budget_row).should eq(budget_row)
      end

      it 'redirects to the budget_row' do
        budget_row = mock_budget_row(id: '17', budget_post: double('budget_post', name: 'post'))
        BudgetRow.stub(:find).with(budget_row.id).and_return(budget_row)
        budget_row.stub(:update_attributes).and_return(true)

        put :update, budget_id: @year, id: budget_row.id, budget_row: valid_attributes
        response.should redirect_to(budget_row_path(@year, budget_row))
      end
    end

    describe 'with invalid params' do
      it 'assigns the budget_row as @budget_row' do
        budget_row = mock_budget_row(id: '17', budget_post: double('budget_post', name: 'post'))
        BudgetRow.stub(:find).with(budget_row.id).and_return(budget_row)
        budget_row.stub(:update_attributes).and_return(false)

        put :update, budget_id: @year, id: budget_row.id, budget_row: {}
        assigns(:budget_row).should eq(budget_row)
      end

      it "re-renders the 'edit' template" do
        budget_row = mock_budget_row(id: '17', budget_post: double('budget_post', name: 'post'))
        BudgetRow.stub(:find).with(budget_row.id).and_return(budget_row)
        budget_row.stub(:update_attributes).and_return(false)

        put :update, budget_id: @year, id: budget_row.id, budget_row: {}
        response.should render_template('edit')
      end
    end
  end
end
