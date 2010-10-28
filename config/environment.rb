# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Cashflow::Application.initialize!

require 'casclient'
require 'casclient/frameworks/rails/filter'
CASClient::Frameworks::Rails::Filter.configure(:cas_base_url => "https://login.kth.se")

Sass::Plugin.options[:template_location] = { 'app/stylesheets' => 'public/stylesheets' }
