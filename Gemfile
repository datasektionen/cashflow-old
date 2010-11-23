source 'http://rubygems.org'

gem 'rails', '3.0.0'
gem 'capistrano'
gem 'haml', '>3.0.0'
gem 'workflow'
gem 'authlogic', :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3'
gem 'rubycas-client'
gem 'RedCloth'
gem 'net-ldap'
gem 'paper_trail'
gem 'cancan'
gem 'formtastic', :git => 'git://github.com/justinfrench/formtastic.git', :branch => 'master'
gem 'simple-navigation'
gem 'jquery-rails'
group :production do
  gem 'mysql'
end

group :development do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'ruby-debug'
  gem 'mongrel'
end

# Gems for test environment
group :test do
  gem "rspec-rails", "~> 2.0.0"
  gem 'rcov'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
  gem 'factory_girl_rails'
end
