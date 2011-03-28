def login(person)
  require 'casclient/frameworks/rails/filter'
  CASClient::Frameworks::Rails::Filter.fake(person.username)
  visit '/personer/sign_in'
end

Given /^I am logged in as the person$/ do
  login(@person)
end

Given /^I log in as the person$/ do
  login(@person)
end

Given /^I am not authenticated$/ do
  visit('/people/sign_out')
end

