Feature: Add users
  In order to make our members happy
  We need to register their info

  Scenario: First login
    Given an ldap importable person exists
    When I log in as the person
    Then my credentials should have been retrieved
    And I should see a form for filling in my bank account information
