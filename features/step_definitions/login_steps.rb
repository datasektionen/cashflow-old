Given(/^I (?:log|am logged) in as the person$/) do
  if page.driver.respond_to?(:block_unknown_urls)
    page.driver.try(:block_unknown_urls)
  end
  begin
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:cas, uid: @person.ugid)

    visit(new_session_path)
  rescue Net::LDAP::Error => _e
    pending "Set up a connection to LDAP to run this test"
  end
end

Given(/^I am not authenticated$/) do
  visit("/sign_out")
end
