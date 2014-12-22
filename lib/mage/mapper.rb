require 'singleton'
require 'yaml/store'

module Mage
  class Mapper
    include Singleton

    def organ_number(business_unit)
      store.transaction do
        store.fetch('business_units').fetch(business_unit.id, {})['organ_number']
      end
    end

    def series(business_unit)
      store.transaction do
        store.fetch('business_units').fetch(business_unit.id, {})['default_series']
      end
    end

    def arrangement_number(budget_post)
      store.transaction do
        store.fetch('budget_posts').fetch(budget_post.id, {})['arrangement_number']
      end
    end

    def account_number(product_type)
      store.transaction do
        store.fetch('product_types').fetch(product_type.id, {})['account_number']
      end
    end

    %w(organ_number series arrangement_number account_number).each do |method|
      define_method "#{method}!" do |arg|
        public_send(method, arg) or fail KeyError, "Unknown #{method} mapping for #{arg.inspect}"
      end
    end

    def save(new_mappings)
      store.transaction do
        store['business_units'] = {}
        new_mappings.fetch('business_units').each do |id, values|
          store['business_units'][id.to_i] = values.to_hash
        end

        store['budget_posts'] = {}
        new_mappings.fetch('budget_posts').each do |id, values|
          store['budget_posts'][id.to_i] = values.to_hash
        end

        store['product_types'] = {}
        new_mappings.fetch('product_types').each do |id, values|
          store['product_types'][id.to_i] = values.to_hash
        end
      end
    end

    private

    def store
      @store ||= YAML::Store.new('config/mage_mappings.yml')
    end
  end
end
