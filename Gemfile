source 'http://rubygems.org'

gem 'rails', '3.0.0'
gem 'capistrano'
gem 'haml', '>3.0.0'
gem 'workflow'
gem 'devise'
gem 'rubycas-client', :git => "https://github.com/gunark/rubycas-client.git"
gem 'devise_cas_authenticatable'
gem 'RedCloth'
gem 'net-ldap'
gem 'paper_trail'
gem 'cancan'
gem 'formtastic', '~> 1.2.3'
gem 'simple-navigation'
gem 'jquery-rails'
gem 'i18n_routing'
gem 'friendly_id'

group :production do
  gem 'mysql2'
end

group :development do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'ruby-debug'
  gem 'mongrel'
end

# Gems for test environment
group :test do
  gem "rspec-rails"
  gem 'rcov'
  gem 'shoulda'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
  gem 'factory_girl_rails'
end
