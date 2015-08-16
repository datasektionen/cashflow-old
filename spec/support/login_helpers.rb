module LoginHelpers
  def login_as(person)
    if page.driver.respond_to?(:block_unknown_urls)
      page.driver.try(:block_unknown_urls)
    end

    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:cas, uid: person.ugid)

    begin
      visit(new_session_path)
    rescue Net::LDAP::Error
      skip "Set up a connection to LDAP to run this test"
    end
  end
end
