class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  layout "anonymous"

  def index
    @page_title = "start"
  end
end
