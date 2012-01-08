# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require "cover_me"
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'controller_macros'
require 'formtastic'

#require 'database_cleaner'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

local_config = YAML.load(File.read("#{Rails.root}/config/local.yml"))
ActiveRecord::Observer.disable_observers
RSpec.configure do |config|
  config.mock_with :rspec
  config.fail_fast = false
  config.use_transactional_fixtures = false

  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
  config.include Devise::TestHelpers, :type => :view
  config.extend ControllerMacros, :type => :view

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

end
