Feature: Manage budgets
  In order to estimate and keep track of spendings
  As an admin
  I want to be able to manage budgets

  Background:
    Given budget rows exist with the following attributes:
      | budget_post_name | sum | year            |
      | Alpha            | 100 | Time.now.year   |
      | Beta             | 200 | Time.now.year   |
      | Gamma            | 300 | Time.now.year-1 |
  
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
