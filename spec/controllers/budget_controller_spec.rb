require 'spec_helper'
require 'mage_api'

describe BudgetController, type: :controller do
  login_admin

  context 'GET' do
    before(:all) do
      @year = Time.now.year
    end

    describe 'index' do
      it "redirects to the current year's budget" do
        get :index
        expect(response).to redirect_to budget_path(id: @year)
      end
    end

    describe 'show' do
      it "assigns the selected year's budget_rows as @budget_rows" do
        rows = [mock_model(BudgetRow), mock_model(BudgetRow)]
        allow(BudgetRow).to receive(:year) { rows }
        get :show, id: @year
        expect(assigns(:budget_rows)).to eq rows
      end
    end

    describe 'edit' do
      it "assigns the selected year's budget_rows as @budget_rows" do
        rows = [mock_model(BudgetRow), mock_model(BudgetRow)]
        allow(BudgetRow).to receive(:year) { rows }
        get :show, id: @year
        expect(assigns(:budget_rows)).to eq rows
      end
    end
  end

  describe 'PUT update' do
    before(:all) do
      @year = Time.now.year
    end

    describe 'with valid params' do
      it "updates the selected year's budget_rows" do
        rows = [Factory(:budget_row), Factory(:budget_row)]
        budget_rows = {}
        budget_posts = {}

        rows.map do |row|
          budget_rows[row.id] = { sum: row.sum + 1000 }
          budget_posts[row.budget_post.id] = { mage_arrangement_number: row.budget_post.mage_arrangement_number + 1 }
        end
        put :update, id: @year, budget_rows: budget_rows, budget_posts: budget_posts
        rows.map do |row|
          expect(BudgetRow.find(row.id).sum).to eq(row.sum + 1000)
          expect(BudgetPost.find(row.budget_post.id).mage_arrangement_number).to eq(row.budget_post.mage_arrangement_number + 1)
        end
      end

      it "redirects to the selected year's budget" do
        rows = [Factory(:budget_row), Factory(:budget_row)]
        budget_rows = {}
        budget_posts = {}

        rows.map do |row|
          budget_rows[row.id] = { sum: row.sum + 1000 }
          budget_posts[row.budget_post.id] = { mage_arrangement_number: row.budget_post.mage_arrangement_number + 1 }
        end

        put :update, id: @year, budget_rows: budget_rows, budget_posts: budget_posts
        expect(response).to redirect_to budget_path(id: @year)
      end
    end

    describe 'with invalid params' do
      it "re-renders the 'edit' template" do
        initialize_mage_webmock
        params = { foo: { bar: 'baz' } }
        put :update, id: @year, foo: params
        expect(response).to render_template('edit')
      end
    end
  end
end
