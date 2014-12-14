require 'spec_helper'

describe BudgetRowsController do
  describe 'routing' do
    it 'routes to #index' do
      get("/budget/#{Time.now.year}/budget_rows").should route_to('budget_rows#index', budget_id: Time.now.year.to_s)
    end

    it 'routes to #show' do
      get("/budget/#{Time.now.year}/budget_rows/1").should route_to('budget_rows#show', id: '1', budget_id: Time.now.year.to_s)
    end

    it 'routes to #edit' do
      get("/budget/#{Time.now.year}/budget_rows/1/edit").should route_to('budget_rows#edit', id: '1', budget_id: Time.now.year.to_s)
    end

    it 'routes to #update' do
      put("/budget/#{Time.now.year}/budget_rows/1").should route_to('budget_rows#update', id: '1', budget_id: Time.now.year.to_s)
    end
  end
end
