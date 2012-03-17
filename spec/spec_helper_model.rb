ENV["RAILS_ENV"] ||= 'test'
require "ostruct"

RAILS_ROOT = Pathname.new(File.expand_path("../..", __FILE__))

require 'active_support'
require 'active_support/dependencies'
%w[helpers validators mailers models cashflow].each do |dir|
  ActiveSupport::Dependencies.autoload_paths << File.expand_path("../../app/#{dir}", __FILE__)
end


require "active_record"
ActiveRecord::Base.establish_connection(
  YAML.load(File.read(RAILS_ROOT + "config/database.yml"))["test"]
)

# We hates Devise :(
class ActiveRecord::Base
  def self.devise *parameters 
  end 
  def self.define_index *parameters
  end
  #; def configurations; configs; end
end
module Devise
  module Models
    module Recoverable
    end 
  end 
end

class Person < ActiveRecord::Base
  attr_writer :password
  def self.has_own_preferences *parameters
  end 
end
require_relative "../app/models/person"


require "factory_girl_rails"
require 'factories'

require 'database_cleaner'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

local_config = YAML.load(File.read("#{RAILS_ROOT}/config/local.yml"))
RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
end

ActiveRecord::Base.send(:configurations=, YAML::load(ERB.new(IO.read(RAILS_ROOT + "config/database.yml")).result))

def Rails.root
  RAILS_ROOT
end

# settings hack
module Cashflow
  class Application
    def self.settings=(settings)
      @@settings = settings
    end
    def self.settings
      @@settings
    end
  end
end

require  "#{RAILS_ROOT}/config/initializers/00_load_configuration.rb"
