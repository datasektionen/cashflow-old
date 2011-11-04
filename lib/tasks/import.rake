# -*- encoding: utf-8 -*-

require 'csv'

desc "Imports budget posts from bp.csv"
task :import_budget_posts => :environment do
  CSV.open('bp.csv','r').each do |l|
    BudgetPost.create(:name=>l[0],:business_unit=>BusinessUnit.find_by_name("Mottagningen"))
  end
end

task :import_organ_numbers_from_mage => :environment do
  Mage::Organ.all.each do |o|
    bu = BusinessUnit.find_by_name(o.name)
    if bu
      bu.mage_number = o.number
      bu.save
      puts "BusinessUnit #{bu.name} == Mage Organ #{o.name} (#{o.number})"
    else
      puts "Found no matching BusinessUnit for Mage Organ #{o.name} (#{o.number})"
    end
  end
end

task :import_account_numbers_from_mage => :environment do
  Mage::Account.all.each do |a|
    pt = ProductType.find_by_name(a.name)
    pt = ProductType.find_by_name(a.name.gsub(/Inköp /,"")) unless pt
    pt = ProductType.find_by_description(a.name) unless pt
    if pt
      pt.mage_account_number = a.number
      pt.save
      puts "ProductType #{pt.name} == Mage Account #{a.name} (#{a.number})"
    else
      puts "Found no matching ProductType for  Mage Account #{a.name} (#{a.number})"
    end
  end
end

task :import_arrangement_numbers_from_mage => :environment do
  Mage::Arrangement.all.each do |a|
    bp = BudgetPost.find_by_name(a.name)
    if bp
      bp.mage_arrangement_number = a.number
      bp.save
      puts "BudgetPost #{bp.name} == Mage Arrangement #{a.name} (#{a.number})"
    else
      puts "Found no matching BudgetPost for Mage Arrangement #{a.name} (#{a.number})"
    end
  end
end
