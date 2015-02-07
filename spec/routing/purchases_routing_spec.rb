require 'spec_helper'

describe PurchasesController do
  describe 'routing' do
    it 'recognizes and generates #index' do
      expect({ get: '/purchases' }).to route_to(controller: 'purchases', action: 'index')
    end

    it 'recognizes and generates #new' do
      expect({ get: '/purchases/new' }).to route_to(controller: 'purchases', action: 'new')
    end

    it 'recognizes and generates #show' do
      expect({ get: '/purchases/1' }).to route_to(controller: 'purchases', action: 'show', id: '1')
    end

    it 'recognizes and generates #edit' do
      expect({ get: '/purchases/1/edit' }).to route_to(controller: 'purchases', action: 'edit', id: '1')
    end

    it 'recognizes and generates #create' do
      expect({ post: '/purchases' }).to route_to(controller: 'purchases', action: 'create')
    end

    it 'recognizes and generates #update' do
      expect({ put: '/purchases/1' }).to route_to(controller: 'purchases', action: 'update', id: '1')
    end

    it 'recognizes and generates #destroy' do
      expect({ delete: '/purchases/1' }).to route_to(controller: 'purchases', action: 'destroy', id: '1')
    end
  end
end
