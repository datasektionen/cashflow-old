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
        response.should redirect_to budget_path(id: @year)
      end
    end

    describe 'show' do
      it "assigns the selected year's budget_rows as @budget_rows" do
        rows = [mock_model(BudgetRow), mock_model(BudgetRow)]
        BudgetRow.stub(:year).and_return { rows }
        get :show, id: @year
        assigns(:budget_rows).should eq rows
      end
    end

    describe 'edit' do
      it "assigns the selected year's budget_rows as @budget_rows" do
        rows = [mock_model(BudgetRow), mock_model(BudgetRow)]
        BudgetRow.stub(:year).and_return { rows }
        get :show, id: @year
        assigns(:budget_rows).should eq rows
      end
    end
  end

  describe 'PUT update' do
    before(:each) do
      @year = Time.now.year
      @rows = [Factory(:budget_row), Factory(:budget_row)]
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

        sums_from_db.should == @rows.map { |r| r.sum + 1000 }
        mage_arr_numbers.should ==
          @posts.map { |p| p.mage_arrangement_number + 1 }
      end

      it "redirects to the selected year's budget" do
        put :update, params.merge(id: @year)
        response.should redirect_to budget_path(id: @year)
      end
    end

    describe 'with invalid params' do
      it "re-renders the 'edit' template" do
        initialize_mage_webmock
        params = { foo: { bar: 'baz' } }
        put :update, id: @year, foo: params
        response.should render_template('edit')
      end

      context "rollback" do
        it "doesn't update anything if budget row entry is invalid" do
          @rows_params[@rows.first.id][:sum] = -4711

          put :update, params.merge(id: @year)

          sums_from_db = BudgetRow.where(id: @rows.map(&:id)).map(&:sum)
          mage_arr_numbers = BudgetPost.where(id: @posts.map(&:id)).
            map(&:mage_arrangement_number)

          sums_from_db.should == @rows.map(&:sum)
          mage_arr_numbers.should == @posts.map(&:mage_arrangement_number)
        end

        it "doesn't update anything if a budget post is invalid" do
          @posts_params[@posts.first.id][:mage_arrangement_number] = nil

          put :update, params.merge(id: @year)

          sums_from_db = BudgetRow.where(id: @rows.map(&:id)).map(&:sum)
          mage_arr_numbers = BudgetPost.where(id: @posts.map(&:id)).
            map(&:mage_arrangement_number)

          sums_from_db.should == @rows.map(&:sum)
          mage_arr_numbers.should == @posts.map(&:mage_arrangement_number)
        end
      end
    end
  end
end
