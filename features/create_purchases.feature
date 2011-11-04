Feature: Registering purchases
  In order to get money back for my purchases
  As a chapter member
  I need to be able to register my purchases

  Background:
    Given I am logged in
    And I have made a purchase that needs registering

  @javascript
  Scenario: Registering a purchase with a single item
    When I fill out the new purchase form accordingly
    Then my purchase should be registered
