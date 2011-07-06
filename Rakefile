# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
task :default => ['spec', 'cucumber' ]
task :with_jasmine => ['jasmine:ci', 'spec', 'cucumber']

Locations::Application.load_tasks
