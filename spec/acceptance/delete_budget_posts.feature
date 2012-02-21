Feature: Delete budget posts

  Background:
    Given I am admin
    And I am logged in

  @javascript
  Scenario: Deleting a budget post with purchases
    Given a budget post exists with a bunch of purchases
    When I try to delete it
    Then it should not be deleted

  @javascript
  Scenario: Deleting a budget post without purchases
    Given a budget post exists without any purchases
    When I try to delete it
    Then it should be deleted
