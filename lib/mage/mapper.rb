require 'singleton'

module Mage
  class Mapper
    include Singleton

    def organ_number(business_unit)
      mappings.fetch('business_units').fetch(business_unit.id).fetch('organ_number')
    end

    def series(business_unit)
      mappings.fetch('business_units').fetch(business_unit.id).fetch('default_series')
    end

    def arrangement_number(budget_post)
      mappings.fetch('budget_posts').fetch(budget_post.id).fetch('arrangement_number')
    end

    def account_number(product_type)
      mappings.fetch('product_types').fetch(product_type.id).fetch('account_number')
    end

    private

    def mappings
      @mappings ||= YAML.load(File.read('config/mage_mappings.yml'))
    end
  end
end
