Given /^I visit "([^"]*)"$/ do |site|
  visit site
end

Then /^I sleep (\d+) seconds$/ do |time|
  sleep time.to_i
end

Given /^I am geolocated to "([^"]*)"$/ do |location|
  visit "/?#{location}"
end

