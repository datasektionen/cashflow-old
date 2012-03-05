Feature: Managing purchases
  In order to make our members happy
  As a treasurer
  I want to manage purchases made
  
  Background:
    Given a person with the "treasurer" role
    And I am logged in as the person
    
  @wip
  Scenario: Confirming a made purchase
  
  @wip
  Scenario: Rejecting a bad purchase
  
  @wip
  Scenario: Cancelling an edited purchase
  
  @wip
  Scenario: Marking a confirmed purchase as bookkept

  @wip
  Scenario: Marking a confirmed purchase as payed

  @wip
  Scenario: Finalizing a confirmed purchase

  @wip
  Scenario: Finalizing a payed purchase

  @javascript
  Scenario: Editing a purchase
    Given a purchase
    When I edit the description of that purchase
    Then the description should be updated
