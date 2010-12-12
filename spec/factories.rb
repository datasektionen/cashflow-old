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

Factory.sequence :type_name do |n|
  product_types[rand(product_types.length)]
end

Factory.define :debt do |f|
  f.description {"blubb"}
  f.amount { rand(1000) }
  f.person { Factory :person }
  f.business_unit { Factory :business_unit }
  f.author { Factory :treasurer }
end

Factory.define :business_unit do |f|
  name = Factory.next :unit_name
  f.name { name }
  f.short_name { name.slice(0,3) }
  f.description {"blubb"}
  f.active {true}
end

Factory.define :product_type do |f|
  f.name    { "product type #{Factory.next :type_name}"}
  f.description { "autogenerated testing product type" }
end

Factory.define :person, :class => Person do |f|
  f.login "blame"
  f.first_name "Martin"
  f.last_name "Frost"
  f.email { Factory.next :email }
  f.ugid { Factory.next :ugid}
end

Factory.define :purchase do |f|
  f.person        { Factory :person }
  f.description   { "test purchase" }
  f.created_by    { Factory :person }
  f.updated_by    { Factory :person }
  f.business_unit { Factory :business_unit }
  f.purchased_at  { Date.today }
end

Factory.define :purchase_item do |f|
  f.purchase  { Factory :purchase }
  f.comment   { "blubb" }
  f.product_type { Factory :product_type }
  f.amount    { 17.0 }
end

Factory.define :admin, :parent => :person do |f|
  f.role "admin"
end

Factory.define :treasurer, :parent => :person do |f|
  f.role "treasurer"
end

Factory.define :accountant, :parent => :person do |f|
  f.role "accountant"
end

