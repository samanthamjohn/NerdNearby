source 'http://rubygems.org'

gem 'rails', "3.1.0.rc1"
gem 'heroku'
gem 'instagram', git: "git://github.com/smj2118/instagram-ruby-gem.git"
gem 'faraday', '0.6.1'
gem 'faraday_middleware', '0.6.3'
gem 'flickraw'
gem 'haml'
gem 'quimby', require: 'foursquare'
gem 'twitter'
gem 'rake', '~> 0.8.7'
# Rails 3.1 - Asset Pipeline
gem 'json'
gem 'sass'
gem 'coffee-script'
gem 'uglifier'
# Rails 3.1 - Javascript
gem "jquery-rails"

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'


# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Rails 3.1 - Heroku
group :production do
   gem 'therubyracer-heroku', '0.8.1.pre3'
   gem 'pg'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'jasmine'
  #   gem 'webrat'
  gem 'factory_girl'
  gem 'rspec-rails'
end

group :test do
  gem 'cucumber-rails'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'spork'
  gem 'capybara'
  gem 'mocha'
  gem 'timecop'
end
