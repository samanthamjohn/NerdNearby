Feature: Smoke Test
  As the developers
  We want the app to be up
  So that we aren't embarrassed

@wip @javascript
Scenario: Smoke Test
  Given I visit "http://nerdnearby.com/?lat=40.7342195&lng=-73.9911255"
  Then I should see "nerd"
  Then I should see "nearby"
  And I sleep 6 seconds
  Then I should see "Like"

@javascript
Scenario: Smoke Test Local
  Given I am geolocated to "lat=40.7342195&lng=-73.9911255"
  Then I should see "nerd"
  Then I should see "nearby"
  And I sleep 6 seconds
  Then I should see "Like"


