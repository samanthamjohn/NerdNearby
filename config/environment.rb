# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Locations::Application.initialize!
Locations::Application.configure do
  config.gem "jammit"
end
