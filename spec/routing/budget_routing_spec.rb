require 'spec_helper'

describe BudgetController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/budget')).to route_to('budget#index')
    end

    xit 'routes to #new' do
      expect(get('/budget_posts/new')).to route_to('budget_posts#new')
    end

    it 'routes to #show' do
      expect(get("/budget/#{Time.now.year}")).to route_to('budget#show', id: Time.now.year.to_s)
    end

    it 'routes to #edit' do
      expect(get("/budget/#{Time.now.year}/edit")).to route_to('budget#edit', id: "#{Time.now.year}")
    end

    xit 'routes to #create' do
      expect(post('/budget_posts')).to route_to('budget_posts#create')
    end

    it 'routes to #update' do
      expect(put("/budget/#{Time.now.year}")).to route_to('budget#update', id: "#{Time.now.year}")
    end

    it 'routes to #destroy' do
      expect(delete('/budget/1')).not_to be_routable
    end
  end
end
