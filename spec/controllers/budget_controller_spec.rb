require 'spec_helper'
require 'mage_api'

describe BudgetController do
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
    before(:each) do
      @year = Time.now.year
      @rows = [create(:budget_row), create(:budget_row)]
      @posts = @rows.map(&:budget_post)
      @rows_params = Hash[*@rows.flat_map { |r| [r.id, { sum: r.sum + 1000 }]}]
      @posts_params = Hash[*@posts.flat_map do |p|
        [p.id, { mage_arrangement_number: p.mage_arrangement_number + 1 }]
      end]

    end

    let(:params) { { budget_rows: @rows_params, budget_posts: @posts_params } }

    describe 'with valid params' do
      it "updates the selected year's budget_rows" do
        put :update, params.merge(id: @year)

        sums_from_db = BudgetRow.where(id: @rows.map(&:id)).map(&:sum)
        mage_arr_numbers = BudgetPost.where(id: @posts.map(&:id)).
          map(&:mage_arrangement_number)

        expect(sums_from_db).to eq(@rows.map { |r| r.sum + 1000 })
        expect(mage_arr_numbers).to eq(
          @posts.map { |p| p.mage_arrangement_number + 1 }
        )
      end

      it "redirects to the selected year's budget" do
        put :update, params.merge(id: @year)
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

      context "rollback" do
        it "doesn't update anything if budget row entry is invalid" do
          @rows_params[@rows.first.id][:sum] = -4711

          put :update, params.merge(id: @year)

          sums_from_db = BudgetRow.where(id: @rows.map(&:id)).map(&:sum)
          mage_arr_numbers = BudgetPost.where(id: @posts.map(&:id)).
            map(&:mage_arrangement_number)

          expect(sums_from_db).to eq(@rows.map(&:sum))
          expect(mage_arr_numbers).to eq(@posts.map(&:mage_arrangement_number))
        end

        it "doesn't update anything if a budget post is invalid" do
          @posts_params[@posts.first.id][:mage_arrangement_number] = nil

          put :update, params.merge(id: @year)

          sums_from_db = BudgetRow.where(id: @rows.map(&:id)).map(&:sum)
          mage_arr_numbers = BudgetPost.where(id: @posts.map(&:id)).
            map(&:mage_arrangement_number)

          expect(sums_from_db).to eq(@rows.map(&:sum))
          expect(mage_arr_numbers).to eq(@posts.map(&:mage_arrangement_number))
        end
      end
    end
  end
end
