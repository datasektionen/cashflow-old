Given /^a person with the "([^"]*)" role$/ do |role|
  @person = Factory(role.to_sym)
end

Then /^my credentials should have been retrieved$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a form for filling in my bank account information$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am logged in$/ do
  unless @person
    Given 'a person with the "person" role'
  end
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:cas, uid: @person.ugid)
  visit('/users/auth/cas')
end

Given /^I am admin$/ do
  @person ||= Factory :person
  @person.role = 'admin'
  @person.save
  @person.reload
end
