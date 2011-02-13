# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'authlogic/test_case'
include Authlogic::TestCase

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

local_config = YAML.load(File.read("#{Rails.root}/config/local.yml"))

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  
  CASClient::Frameworks::Rails::Filter.fake(local_config[:yourself][:ugid])

  
end

Person.create_from_ldap(:ugid => local_config[:yourself][:ugid])
def login
  session[:cas_user] = local_config[:yourself][:ugid]
  session.update
  @current_user = Person.find_by_ugid(session[:cas_user])
  @current_user_session = PersonSession.create(@current_user)
end

