# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application

module Cashflow
  class Application < Rails::Application
    attr_accessor :settings
    config.encoding = "utf-8"
  end
end

Cashflow::Application.initialize!

Sass::Plugin.options[:template_location] = { 'app/stylesheets' => 'public/stylesheets' }
