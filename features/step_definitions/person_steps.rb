Given /^a person with the "([^"]*)" role$/ do |role|
  @person = Factory(role.to_sym)
end
