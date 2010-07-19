class WelcomeController < ApplicationController
  skip_before_filter :cas_filter #CASClient::Frameworks::Rails::Filter
  
  def index
  end
end
