namespace :mage do
  task export_mappings: :environment do
    require 'yaml/store'
    store_path = './config/mage_mappings.yml'
    store = YAML::Store.new(store_path)

    store.transaction do
      store['business_units'] = {}
      BusinessUnit.find_each do |business_unit|
        store['business_units'][business_unit.id] ||= {}
        store['business_units'][business_unit.id]['organ_number'] = business_unit.mage_number
        store['business_units'][business_unit.id]['default_series'] ||= business_unit.mage_default_series
      end
    end

    store.transaction do
      store['budget_posts'] = {}
      BudgetPost.find_each do |budget_post|
        store['budget_posts'][budget_post.id] ||= {}
        store['budget_posts'][budget_post.id]['arrangement_number'] = budget_post.mage_arrangement_number
      end
    end

    store.transaction do
      store['product_types'] = {}
      ProductType.find_each do |product_type|
        store['product_types'][product_type.id] ||= {}
        store['product_types'][product_type.id]['account_number'] = product_type.mage_account_number
      end
    end

    puts "Mappings saved to #{store_path}"
  end
end
