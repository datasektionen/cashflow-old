source 'http://rubygems.org'

gem 'rails', '3.0.0'
gem 'haml', '>3.0.0'
gem 'workflow'
gem 'devise'
gem "oa-enterprise", "~> 0.2.0"
gem 'RedCloth'
gem 'net-ldap'
gem 'paper_trail'
gem 'cancan'#, :git => "git://github.com/ryanb/cancan.git", :branch => "2.0"
gem 'formtastic', '~> 1.2.3'
gem 'simple-navigation'
gem 'jquery-rails'
gem 'i18n_routing'
gem 'friendly_id'
gem 'cocoon'

group :production do
  gem 'mysql2'
  gem 'unicorn'
end

group :development do
  gem 'linecache19'
  gem 'ruby-debug19', :require => "ruby-debug"
end

# Gems for test environment
group :test do
  gem "rspec-rails"
  gem "rspec-mocks"
  gem 'rcov'
  gem 'shoulda'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'autotest'
  gem 'autotest-growl'
  gem 'autotest-fsevent' if RUBY_PLATFORM =~ /darwin/
  gem 'launchy'    # So you can do Then show me the page
  gem 'factory_girl_rails'
end

group :deploy do
  gem 'capistrano'
  gem 'capistrano-ext'
end
