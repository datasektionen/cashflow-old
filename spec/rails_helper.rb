require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
ENV["RAILS_ENV"] ||= "test"

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start "rails"
end

require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "controller_macros"
require "formtastic"
require "database_cleaner"
require "webmock/rspec"
require "paper_trail/frameworks/rspec"
require "capybara/rspec"
Capybara.javascript_driver = :webkit

WebMock.disable_net_connect!(allow: "codeclimate.com", allow_localhost: true)

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false

  config.include Rails.application.routes.url_helpers
  config.include Devise::TestHelpers, type: :controller
  config.include DefaultParams, type: :controller
  config.include LoginHelpers, type: :feature
  config.extend ControllerMacros, type: :controller

  config.include Devise::TestHelpers, type: :view
  config.extend ControllerMacros, type: :view

  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!

  config.before(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:deletion)
  end

  config.profile_examples = 10
end
