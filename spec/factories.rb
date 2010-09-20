require 'digest/md5'

srand(4711)

product_types = [
  "förbrukningsvaror",
  "förbrukningsinventarier",
  "inventarier",
  "inredning",
  "mat"
]

business_units = [
  "DKM",
  "Mottagningen",
  "QN",
  "Ior",
  "ESCapo",
  "Drek"
]

Factory.sequence :unit_name do |n|
  business_units[rand(business_units.length)]
end

Factory.sequence :ugid do |n|
  "u1" + Digest::MD5.hexdigest(n.to_s).slice(0,6)
end

Factory.sequence :email do |n|
  "test-#{n}@example.com"
end

Factory.define :debt do |f|
  f.description {"blubb"}
  f.amount { rand(1000) }
  f.person { Factory :person }
  f.business_unit { Factory :business_unit }
  f.author { Factory :cashier }
end

Factory.define :business_unit do |f|
  name = Factory.next :unit_name
  f.name { name }
  f.short_name { name.slice(0,3) }
  f.description {"blubb"}
  f.active {true}
end

Factory.define :person, :class => Person do |f|
  f.login "blame"
  f.first_name "Martin"
  f.last_name "Frost"
  f.email { Factory.next :email }
  f.ugid { Factory.next :ugid}
  f.role "user"
end

Factory.define :admin, :parent => :person do |f|
  f.role "admin"
end

Factory.define :cashier, :parent => :person do |f|
  f.role "cashier"
end
