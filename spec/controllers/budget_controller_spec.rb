require "spec_helper"

describe BudgetController do
  login_admin

  context "GET" do

    before(:all) do
      @year = Time.now.year
    end

    describe "index" do
      it "redirects to the current year's budget" do
        get :index
        response.should redirect_to budget_path(:id => @year)
      end
    end

    describe "show" do
      it "assigns the selected year's budget_rows as @budget_rows" do
        rows = [mock_model(BudgetRow), mock_model(BudgetRow)]
        BudgetRow.stub!(:year).and_return { rows }
        get :show, :id => @year
        assigns(:budget_rows).should eq rows
      end
    end

    describe "edit" do
      it "assigns the selected year's budget_rows as @budget_rows" do
        rows = [mock_model(BudgetRow), mock_model(BudgetRow)]
        BudgetRow.stub!(:year).and_return { rows }
        get :show, :id => @year
        assigns(:budget_rows).should eq rows
      end
    end
  end

  describe "PUT update" do

    before(:all) do
      @year = Time.now.year
    end

    describe "with valid params" do
      it "updates the selected year's budget_rows" do
        rows = [Factory(:budget_row), Factory(:budget_row)]
        params = {}
        rows.map do |row|
          params[row.id] = {sum: row.sum + 1000 }  
        end
        put :update, id: @year, budget_rows: params
        rows.map do |row|
          BudgetRow.find(row.id).sum.should == row.sum + 1000
        end
      end

      it "redirects to the selected year's budget" do
        rows = [Factory(:budget_row), Factory(:budget_row)]
        params = {}
        rows.map {|row| params[row.id] = {sum: row.sum += 1000 }}
        put :update, id: @year, budget_rows: params
        response.should redirect_to budget_path(id: @year)
      end
    end

    describe "with invalid params" do
      it "re-renders the 'edit' template" do
        params = {foo: {bar: 'baz'}}
        put :update, id: @year, foo: params
        response.should render_template('edit')
      end
    end
  end
end
