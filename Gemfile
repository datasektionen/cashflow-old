source 'http://rubygems.org'

gem 'rails', '~> 3.0.0'
gem 'haml', '~>3.0.0'
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
gem 'mysql2', '~> 0.2.0'

group :production do
  gem 'unicorn'
end

group :development do
  gem 'linecache19'
  gem 'ruby-debug19', :require => "ruby-debug"
end

# Gems for test environment
group :test do
  gem 'no_peeping_toms', :git => "https://github.com/dbalatero/no-peeping-toms.git"
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
  gem 'launchy'    # So you can do Then show me the page
  gem 'factory_girl_rails'
end

group :deploy do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano_colors'
end
