require 'spec_helper'

describe BusinessUnitsController do
  describe 'routing' do
    it 'recognizes and generates #index' do
      { get: '/business_units' }.should route_to(controller: 'business_units', action: 'index')
    end

    it 'recognizes and generates #new' do
      { get: '/business_units/new' }.should route_to(controller: 'business_units', action: 'new')
    end

    it 'recognizes and generates #show' do
      { get: '/business_units/1' }.should route_to(controller: 'business_units', action: 'show', id: '1')
    end

    it 'recognizes and generates #edit' do
      { get: '/business_units/1/edit' }.should route_to(controller: 'business_units', action: 'edit', id: '1')
    end

    it 'recognizes and generates #create' do
      { post: '/business_units' }.should route_to(controller: 'business_units', action: 'create')
    end

    it 'recognizes and generates #update' do
      { put: '/business_units/1' }.should route_to(controller: 'business_units', action: 'update', id: '1')
    end

    it 'recognizes and generates #destroy' do
      { delete: '/business_units/1' }.should route_to(controller: 'business_units', action: 'destroy', id: '1')
    end
  end
end
