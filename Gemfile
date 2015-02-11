source "https://rubygems.org"

gem "rails", "~> 4.1.0"

# Auth
gem "devise", "~> 3.4.0"
gem "omniauth", "~> 1.0"
gem "omniauth-cas", "~> 1.0"
gem "cancancan" # Authz

# Forms
gem "formtastic", "~> 3.1.3"
gem "formtastic-bootstrap"
gem "bootstrap-sass", "= 3.1.1.0"
gem "bootstrap-datepicker-rails"

# Views
gem "sass-rails", ">= 4.0.0"
gem "RedCloth", "~> 4.2.9" # Textile
gem "haml-rails"
gem "haml-contrib" # For rendering textile in haml views

gem "rails-translate-routes" # localized routes
gem "friendly_id"  # pretty routes

# Javascript
gem "jquery-rails"
gem "chosen_rails"
gem "cocoon"
gem "uglifier"

gem "kaminari" # pagination

# Database
gem "pg"
gem "textacular" # Search

gem "net-ldap"          # Import people from LDAP
gem "paper_trail"       # Who did what?
gem "simple-navigation" # Navigation
gem "workflow"          # state machines for purchases
gem "rfc-822"           # validate email

group :production do
  gem "unicorn"
end

group :development do
  gem "pry-nav"
  gem "pry-rails"
  gem "spring"
end

group :development, :test do
  gem "teaspoon"
end

# Gems for test environment
group :test do
  gem "capybara"
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "headless"
  gem "launchy"
  gem "rspec", "~> 3.2.0"
  gem "rspec-rails", "~> 3.2.0"
  gem "rspec-activemodel-mocks"
  gem "capybara-webkit"
  gem "shoulda-matchers"
  gem "simplecov", "~> 0.9", require: false
  gem "webmock"
  gem "codeclimate-test-reporter", require: nil
end
