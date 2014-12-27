require 'spec_helper'

describe ProductTypesController do
  describe 'routing' do
    it 'recognizes and generates #index' do
      expect({ get: '/product_types' }).to route_to(controller: 'product_types', action: 'index')
    end

    it 'recognizes and generates #new' do
      expect({ get: '/product_types/new' }).to route_to(controller: 'product_types', action: 'new')
    end

    it 'recognizes and generates #show' do
      expect({ get: '/product_types/1' }).to route_to(controller: 'product_types', action: 'show', id: '1')
    end

    it 'recognizes and generates #edit' do
      expect({ get: '/product_types/1/edit' }).to route_to(controller: 'product_types', action: 'edit', id: '1')
    end

    it 'recognizes and generates #create' do
      expect({ post: '/product_types' }).to route_to(controller: 'product_types', action: 'create')
    end

    it 'recognizes and generates #update' do
      expect({ put: '/product_types/1' }).to route_to(controller: 'product_types', action: 'update', id: '1')
    end

    it 'recognizes and generates #destroy' do
      expect({ delete: '/product_types/1' }).to route_to(controller: 'product_types', action: 'destroy', id: '1')
    end
  end
end
