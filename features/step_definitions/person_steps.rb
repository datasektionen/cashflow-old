Given(/^a person with the "([^"]*)" role$/) do |role|
  @person = create(role.to_sym)
end

Given(/^an ldap importable person exists$/) do
  @person = build(:person, ugid: "u1dhz6b0")
end

Then(/^my credentials should have been retrieved$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a form for filling in my bank account information$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I am logged in$/) do
  unless @person
    step 'a person with the "person" role'
  end
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:cas, uid: @person.ugid)
  visit('/users/auth/cas')
end

Given(/^I am admin$/) do
  @person ||= create(:person)
  @person.role = 'admin'
  @person.save
  @person.reload
end
