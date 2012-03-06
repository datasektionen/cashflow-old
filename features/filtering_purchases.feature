Feature: Filtering purchases
  In order to streamline the workflow
  As a treasurer
  I want to filter purchases

  Background:
    Given a person with the "treasurer" role
    And I am logged in as the person
    And there exists at least one purchase of each status

  Scenario: No filter specified
    When I go to the purchases page
    Then I should see all purchases

  @wip
  Scenario: Filter by single status
    When I go to the purchases page
    And I filter the purchases by status "new"
    Then I should see new purchases
    And I should not see any other purchases

  @wip
  Scenario: Filter by multiple statuses
    When I go to the purchases page
    And I filter the purchases by statuses "new, edited"
    Then I should see new purchases
    Then I should see edited purchases
    And I should not see any other purchases
