source 'http://rubygems.org'

gem 'rails', '3.0.0.beta4'
gem 'capistrano'
gem 'haml'
gem 'compass', '>0.10.1'
gem 'workflow'
gem 'authlogic'
gem 'rubycas-client'

group :production do
  gem 'mysql'
end

group :development do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'ruby-debug'
end

# Gems for test environment
group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'rspec-rails'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
  gem 'factory_girl_rails'
end