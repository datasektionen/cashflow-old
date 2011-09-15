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
    describe "with valid params" do
      it "updates the selected year's budget_rows"
      it "assigns the selected year's budget_rows as @budget_rows"
      it "redirects to the selected year's budget"
    end

    describe "with invalid params" do
      it "assigns the selected year's budget_rows as @budget_rows"
      it "re-renders the 'edit' template"
    end
  end
end
