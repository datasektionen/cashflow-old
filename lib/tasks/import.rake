# -*- encoding: utf-8 -*-

require 'csv'

desc 'Imports budget posts from bp.csv'
task import_budget_posts: :environment do
  CSV.open('bp.csv', 'r').each do |l|
    BudgetPost.create(name: l[0], business_unit: BusinessUnit.find_by_name('Mottagningen'))
  end
end

task import_organ_numbers_from_mage: :environment do
  Mage::Organ.all.each do |o|
    business_unit = BusinessUnit.find_by_name(o.name)
    if business_unit
      business_unit.mage_number = o.number
      business_unit.save
      puts "BusinessUnit #{business_unit.name} == Mage Organ #{o.name} (#{o.number})"
    else
      puts "Found no matching BusinessUnit for Mage Organ #{o.name} (#{o.number})"
    end
  end
end

task import_account_numbers_from_mage: :environment do
  Mage::Account.all(Cashflow::Application.settings['mage_activity_year']).each do |a|
    product_type = ProductType.find_by_name(a.name)
    product_type = ProductType.find_by_name(a.name.gsub(/Inköp /, '')) unless product_type
    product_type = ProductType.find_by_description(a.name) unless product_type
    if product_type
      product_type.mage_account_number = a.number
      product_type.save
      puts "ProductType #{product_type.name} == Mage Account #{a.name} (#{a.number})"
    else
      puts "Found no matching ProductType for  Mage Account #{a.name} (#{a.number})"
    end
  end
end

task import_arrangement_numbers_from_mage: :environment do
  Mage::Arrangement.all(Cashflow::Application.settings['mage_activity_year']).each do |a|
    budget_post = BudgetPost.find_by_name(a.name)
    if budget_post
      budget_post.mage_arrangement_number = a.number
      budget_post.save
      puts "BudgetPost #{budget_post.name} == Mage Arrangement #{a.name} (#{a.number})"
    else
      puts "Found no matching BudgetPost for Mage Arrangement #{a.name} (#{a.number})"
    end
  end
end
