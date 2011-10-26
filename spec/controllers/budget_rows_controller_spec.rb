require 'spec_helper'

describe BudgetRowsController do
  login_admin

  before(:all) do
    @year = Time.now.year
  end

  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @ability.can :access, :all
    @ability.can :manage, :all
    #@controller.stub(:current_ability).and_return(@ability)
  end

  def valid_attributes
    {sum: 1000, year: @year}
  end

  describe "GET index" do
    it "assigns all budget_rows as @budget_rows" do
      budget_post = Factory :budget_post
      budget_row = budget_post.row(@year)
      get :index, budget_id: @year
      assigns(:budget_rows).should eq([budget_row])
    end
  end

  describe "GET show" do
    it "assigns the requested budget_row as @budget_row" do
      budget_post = Factory :budget_post
      budget_row = budget_post.row(@year)
      get :show, budget_id: @year, id: budget_row.id
      assigns(:budget_row).should eq(budget_row)
    end
  end

  describe "GET edit" do
    it "assigns the requested budget_row as @budget_row" do
      budget_post = Factory :budget_post
      budget_row = budget_post.row(@year)
      get :edit, id: budget_row.id, budget_id: @year
      assigns(:budget_row).should eq(budget_row)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested budget_row" do
        budget_post = Factory :budget_post
        budget_row = budget_post.row(@year)
        BudgetRow.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, budget_id: @year, id: budget_row.id, budget_row: {'these' => 'params'}
      end

      it "assigns the requested budget_row as @budget_row" do
        budget_post = Factory :budget_post
        budget_row = budget_post.row(@year)
        put :update, budget_id: @year, id: budget_row.id, budget_row: valid_attributes
        assigns(:budget_row).should eq(budget_row)
      end

      it "redirects to the budget_row" do
        budget_post = Factory :budget_post
        budget_row = budget_post.row(@year)
        put :update, budget_id: @year, id: budget_row.id, budget_row: valid_attributes
        response.should redirect_to(budget_row)
      end
    end

    describe "with invalid params" do
      it "assigns the budget_row as @budget_row" do
        budget_post = Factory :budget_post
        budget_row = budget_post.row(@year)
        # Trigger the behavior that occurs when invalid params are submitted
        BudgetRow.any_instance.stub(:save).and_return(false)
        put :update, budget_id: @year, id: budget_row.id, budget_row: {}
        assigns(:budget_row).should eq(budget_row)
      end

      it "re-renders the 'edit' template" do
        budget_post = Factory :budget_post
        budget_row = budget_post.row(@year)
        # Trigger the behavior that occurs when invalid params are submitted
        BudgetRow.any_instance.stub(:save).and_return(false)
        put :update, budget_id: @year, id: budget_row.id, budget_row: {}
        response.should render_template("edit")
      end
    end
  end

end
