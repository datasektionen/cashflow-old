# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application

module Cashflow
  class Application < Rails::Application
    attr_accessor :settings
    config.encoding = 'utf-8'
    config.active_record.raise_in_transactional_callbacks = true
  end
end

Cashflow::Application.initialize!
