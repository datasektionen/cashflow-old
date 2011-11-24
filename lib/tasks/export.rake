# -*- encoding: utf-8 -*-

desc "Exports accepted purchases to mage"
task :export_purchases => :environment do
   # Only mottagningen
   user = Person.find_by_login("taran")
   PaperTrail.whodunnit = user.id.to_s
   business_unit = BusinessUnit.find_by_short_name("mot")
   complete = Array.new
   business_unit.budget_posts.each do |bp|
      bp.purchases.keepable.each do |p|
         voucher = Mage::Voucher.from_purchase(p,"M")
         if voucher.push user
            puts "Skickade #{voucher.title} till mage"
            complete << p.id
         else
            puts "Kunde inte skicka #{voucher.name} till mage (#{voucher.errors.inspect})"
         end
      end
   end
   puts complete.inspect
end
