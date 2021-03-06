require "rails_helper"

RSpec.describe BudgetRowsController do
  login_admin
  let(:default_params) { { locale: "sv" } }

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
    double("budget_row", valid_attributes.merge(extra_attributes))
  end

  let(:budget_row) {
    mock_budget_row(id: "17",
                    budget_post: double("budget_post", name: "post"))
  }

  describe "GET index" do
    it "assigns all budget_rows as @budget_rows" do
      row = mock_budget_row
      allow(BudgetRow).to receive(:year).with(@year).and_return([row])
      get :index, budget_id: @year
      expect(assigns(:budget_rows)).to eq([row])
    end
  end

  describe "GET show" do
    it "assigns the requested budget_row as @budget_row" do
      allow(BudgetRow).to receive(:find).
                          with(budget_row.id).
                          and_return(budget_row)

      get :show, budget_id: @year, id: budget_row.id
      expect(assigns(:budget_row)).to eq(budget_row)
    end
  end

  describe "GET edit" do
    it "assigns the requested budget_row as @budget_row" do
      allow(BudgetRow).to receive(:find).
                          with(budget_row.id).
                          and_return(budget_row)
      get :edit, id: budget_row.id, budget_id: @year
      expect(assigns(:budget_row)).to eq(budget_row)
    end
  end

  describe "PUT update" do
    before(:each) do
      allow(BudgetRow).to receive(:find).
                                  with(budget_row.id).
                                  and_return(budget_row)
    end
    describe "with valid params" do
      it "updates the requested budget_row" do
        expect(budget_row).to receive(:update_attributes).
                              with("these" => "params")

        params = {
          budget_id: @year,
          id: budget_row.id,
          budget_row: { "these" => "params" }
        }
        put :update, params
      end

      it "assigns the requested budget_row as @budget_row" do
        allow(budget_row).to receive(:update_attributes)

        params = {
          budget_id: @year,
          id: budget_row.id,
          budget_row: valid_attributes
        }
        put :update, params
        expect(assigns(:budget_row)).to eq(budget_row)
      end

      it "redirects to the budget_row" do
        allow(budget_row).to receive(:update_attributes).and_return(true)

        params = {
          budget_id: @year,
          id: budget_row.id,
          budget_row: valid_attributes
        }
        put :update, params
        expect(response).to redirect_to(budget_row_path(@year, budget_row))
      end
    end

    describe "with invalid params" do
      before(:each) do
        allow(BudgetRow).to receive(:find).
                                    with(budget_row.id).
                                    and_return(budget_row)
        allow(budget_row).to receive(:update_attributes).and_return(false)
      end

      it "assigns the budget_row as @budget_row" do
        put :update, budget_id: @year, id: budget_row.id, budget_row: {}
        expect(assigns(:budget_row)).to eq(budget_row)
      end

      it 're-renders the "edit" template' do
        put :update, budget_id: @year, id: budget_row.id, budget_row: {}
        expect(response).to render_template("edit")
      end
    end
  end
end
