require 'digest/md5'

Factory.sequence :ugid do |n|
  "u1" + Digest::MD5.hexdigest(n.to_s).slice(0,6)
end

Factory.sequence :email do |n|
  "test-#{n}@example.com"
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
