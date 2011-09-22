Feature: Manage budgets
  In order to estimate and keep track of spendings
  As an admin
  I want to be able to manage budgets

  Background:
    Given a person with the "treasurer" role
    And I am logged in as the person
    And budget rows exist with the following attributes:
      | budget_post_name | sum | year_offset |
      | Alpha            | 100 | 0           |
      | Beta             | 200 | 0           |
      | Gamma            | 300 | -1          |
  
  Scenario: View budget for the current year
    When I go to the budget page
    Then I should see "Alpha"
    And I should see "Beta"
    And I should not see "Gamma"

  Scenario: View budget for last year
    When I go to the budget page for last year
    Then I should not see "Alpha"
    And I should not see "Beta"
    And I should see "Gamma"

  Scenario: Edit budget for the current year
    When I go to the budget page
    And I press "Ändra budget"
    And I fill in "Alpha" with "400"
    And I press "Spara"
    Then I should be on the budget page
    And I should see "400"

