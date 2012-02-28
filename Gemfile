source 'http://rubygems.org'

gem 'rails', '~> 3.1.0'
gem 'haml-rails'
gem 'workflow'
gem 'devise'
gem 'oa-core'
gem "oa-enterprise"
gem 'RedCloth', "~> 4.2.8"
gem 'net-ldap'
gem 'paper_trail'
gem 'cancan'#, :git => "git://github.com/ryanb/cancan.git", :branch => "2.0"
gem 'formtastic'
gem 'formtastic-bootstrap', git: 'git://github.com/cgunther/formtastic-bootstrap.git', branch: 'bootstrap-2'
gem 'chosen_rails'
gem 'less-rails-bootstrap'
gem 'simple-navigation'
gem 'jquery-rails', '~>1.0.19'
gem 'i18n_routing'
gem 'friendly_id'
gem 'cocoon'
gem 'mysql2'
gem 'decent_exposure'
gem 'uglifier'

group :production do
  gem 'unicorn'
  gem 'exceptional'
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
  gem 'cover_me'
  gem 'shoulda', ">= 3.0.0.beta2"
  gem 'capybara'
  gem 'selenium'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'launchy'    # So you can do Then show me the page
  gem 'factory_girl_rails'
  gem 'libnotify'
  gem 'headless'
  gem 'turnip'
end

group :deploy do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano_colors'
end
