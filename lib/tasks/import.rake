require 'csv'

desc "Imports budget posts from bp.csv"
task :import_budget_posts => :environment do
  CSV.open('bp.csv','r').each do |l|
    BudgetPost.create(:name=>l[0],:business_unit=>BusinessUnit.find_by_name("Mottagningen"))
  end
end
