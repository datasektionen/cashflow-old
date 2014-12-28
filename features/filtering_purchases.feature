Feature: Filtering purchases
  In order to streamline the workflow
  As a treasurer
  I want to filter purchases

  Background:
    Given a person with the "treasurer" role
    And I am logged in as the person
    And there exists at least one purchase of each status
    And I go to the purchases page

  Scenario: No filter specified
    Then I should see all purchases

  @javascript
  Scenario: Filter by single status
    When I filter the purchases by statuses "new"
    Then I should see purchases with statuses "new"
    And I should not see any other purchases

  @javascript
  Scenario: Filter by multiple statuses
    When I filter the purchases by statuses "new, edited"
    Then I should see purchases with statuses "new, edited"
    And I should not see any other purchases

  Scenario: Search purchases by description text
    Given there exists a purchase with "lorem ipsum" in the description
    When I search for "lore"
    Then I should see that purchase among the results
