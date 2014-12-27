require 'spec_helper'

describe PeopleController, type: :controller do
  describe 'routing' do
    it 'recognizes and generates #index' do
      expect({ get: '/people' }).to route_to(controller: 'people', action: 'index')
    end

    it 'recognizes and generates #new' do
      expect({ get: '/people/new' }).to route_to(controller: 'people', action: 'new')
    end

    it 'recognizes and generates #show' do
      expect({ get: '/people/1' }).to route_to(controller: 'people', action: 'show', id: '1')
    end

    it 'recognizes and generates #edit' do
      expect({ get: '/people/1/edit' }).to route_to(controller: 'people', action: 'edit', id: '1')
    end

    it 'recognizes and generates #create' do
      expect({ post: '/people' }).to route_to(controller: 'people', action: 'create')
    end

    it 'recognizes and generates #update' do
      expect({ put: '/people/1' }).to route_to(controller: 'people', action: 'update', id: '1')
    end

    it "doesn't recognize and generate #destroy" do
      expect({ delete: '/people/1' }).not_to be_routable
    end
  end
end
