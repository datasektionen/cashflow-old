# encoding: utf-8
require "digest/md5"

srand(4711)

FactoryGirl.define do
  product_types = %w( förbrukningsvaror
                      förbrukningsinventarier
                      inventarier
                      inredning
                      mat)

  business_units = %w(DKM Mottagningen QN Ior ESCapo Drek)

  budget_posts = %w(BP1 BP2 BP3 BP4 BP5)

  sequence :unit_name do |_n|
    business_units[rand(business_units.length)]
  end

  sequence :ugid do |n|
    "u1" + Digest::MD5.hexdigest(n.to_s).slice(0, 6)
  end

  sequence :email do |n|
    "test-#{n}@example.com"
  end

  sequence :type_name do |_n|
    product_types[rand(product_types.length)]
  end

  sequence :post_name do |_n|
    budget_posts[rand(budget_posts.length)]
  end

  sequence :item_name do |n|
    "blubb #{n}"
  end

  factory :business_unit do
    transient do
      bu_name           { generate :unit_name }
    end
    name { bu_name }
    email { generate :email }
    short_name { bu_name.slice(0, 3) }
    description { "blubb" }
    active { true }
    mage_number { 1 }
    mage_default_series { "C" }
  end

  factory :product_type do
    name                { "product type #{generate :type_name}" }
    description         { "autogenerated testing product type" }
    mage_account_number { 4019 }
  end

  factory :person do
    login "blame"
    first_name "Martin"
    last_name "Frost"
    email { generate :email }
    ugid { generate :ugid }

    Person::ROLES.each do |p_role|
      factory p_role.to_sym do
        role { p_role }
      end
    end
  end

  factory :purchase do
    description   { "test purchase" }
    slug          { "test" }
    purchased_on  { Date.today }
    year          { Time.now.year }
    person
    budget_post

    factory :confirmed_purchase do
      workflow_state "confirmed"
    end
  end

  factory :purchase_item do
    comment   { generate :item_name }
    amount    { 17.0 }
    purchase
    product_type
  end

  factory :budget_post do
    name                    { generate :post_name }
    mage_arrangement_number { 0 }
    business_unit
  end

  factory :budget_row do
    budget_post
    year        { Time.now.year }
    sum         { 0 }
  end
end
