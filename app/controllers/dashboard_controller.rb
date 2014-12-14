class DashboardController < ApplicationController
  before_filter :authenticate_user!, except: :welcome

  def index
    @page_title = 'start'
  end

  def welcome
  end
end
