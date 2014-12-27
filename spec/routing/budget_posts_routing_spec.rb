require 'spec_helper'

describe BudgetPostsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/budget_posts')).to route_to('budget_posts#index')
    end

    it 'routes to #new' do
      expect(get('/budget_posts/new')).to route_to('budget_posts#new')
    end

    it 'routes to #show' do
      expect(get('/budget_posts/1')).to route_to('budget_posts#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get('/budget_posts/1/edit')).to route_to('budget_posts#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post('/budget_posts')).to route_to('budget_posts#create')
    end

    it 'routes to #update' do
      expect(put('/budget_posts/1')).to route_to('budget_posts#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/budget_posts/1')).to route_to('budget_posts#destroy', id: '1')
    end
  end
end
