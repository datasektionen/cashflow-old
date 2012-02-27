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
    Then I should see the current year's budget posts

  Scenario: View budget for last year
    When I go to the budget page for last year
    Then I should see the budget posts for last year

  @wip
  Scenario: Edit budget for the current year
    When I go to the budget page
    And I change the sum of "Alpha" to "400"
    Then I should be on the budget page for the current year

