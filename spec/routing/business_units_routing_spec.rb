require 'spec_helper'

describe BusinessUnitsController, type: :controller do
  describe 'routing' do
    it 'recognizes and generates #index' do
      expect({ get: '/business_units' }).to route_to(controller: 'business_units', action: 'index')
    end

    it 'recognizes and generates #new' do
      expect({ get: '/business_units/new' }).to route_to(controller: 'business_units', action: 'new')
    end

    it 'recognizes and generates #show' do
      expect({ get: '/business_units/1' }).to route_to(controller: 'business_units', action: 'show', id: '1')
    end

    it 'recognizes and generates #edit' do
      expect({ get: '/business_units/1/edit' }).to route_to(controller: 'business_units', action: 'edit', id: '1')
    end

    it 'recognizes and generates #create' do
      expect({ post: '/business_units' }).to route_to(controller: 'business_units', action: 'create')
    end

    it 'recognizes and generates #update' do
      expect({ put: '/business_units/1' }).to route_to(controller: 'business_units', action: 'update', id: '1')
    end

    it 'recognizes and generates #destroy' do
      expect({ delete: '/business_units/1' }).to route_to(controller: 'business_units', action: 'destroy', id: '1')
    end
  end
end
