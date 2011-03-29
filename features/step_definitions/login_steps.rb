def login(person)
  require 'casclient/frameworks/rails/filter'
  CASClient::Frameworks::Rails::Filter.fake(person.username)
end

Given /^I am logged in as the person$/ do
  login(@person)
  visit('/login')
end

Given /^I log in as the person$/ do
  login(@person)
  debugger
  visit('/login')
end

Given /^I am not authenticated$/ do
  visit('/people/sign_out')
end

