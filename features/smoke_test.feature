Feature: Smoke Test
  As the developers
  We want the app to be up
  So that we aren't embarrassed

@javascript
Scenario: Smoke Test
  Given I visit "http://nerdnearby.com"
  Then I should see "nerd"
  Then I should see "nearby"


