Given /^I (?:log|am logged) in as the person$/ do
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:cas, {:uid => @person.ugid })

  visit(new_person_session_path)
end

Given /^I am not authenticated$/ do
  visit('/sign_out')
end

