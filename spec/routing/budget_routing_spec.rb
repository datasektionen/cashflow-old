require 'spec_helper'

describe BudgetController do
  describe 'routing' do
    it 'routes to #index' do
      get('/budget').should route_to('budget#index')
    end

    xit 'routes to #new' do
      get('/budget_posts/new').should route_to('budget_posts#new')
    end

    it 'routes to #show' do
      get("/budget/#{Time.now.year}").should route_to('budget#show', id: Time.now.year.to_s)
    end

    it 'routes to #edit' do
      get("/budget/#{Time.now.year}/edit").should route_to('budget#edit', id: "#{Time.now.year}")
    end

    xit 'routes to #create' do
      post('/budget_posts').should route_to('budget_posts#create')
    end

    it 'routes to #update' do
      put("/budget/#{Time.now.year}").should route_to('budget#update', id: "#{Time.now.year}")
    end

    it 'routes to #destroy' do
      delete('/budget/1').should_not be_routable
    end
  end
end
