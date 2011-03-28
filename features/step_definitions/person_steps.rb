Given /^a person with the "([^"]*)" role$/ do |role|
  @person = Factory(role.to_sym)
end

Then /^my credentials should have been retrieved$/ do
  debugger
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a form for filling in my bank account information$/ do
  pending # express the regexp above with the code you wish you had
end

