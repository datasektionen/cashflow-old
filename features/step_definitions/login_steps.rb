def login(person)  
  CASClient::Frameworks::Rails::Filter.fake(person.ugid)
  visit root_path
end

Given /^I am logged in as the person$/ do
  login(@person)
end

Given /^I log in as the person$/ do
  login(@person)
end