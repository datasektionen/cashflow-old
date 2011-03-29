def login(person)
  debugger
  ""
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
  visit('/sign_out')
end

