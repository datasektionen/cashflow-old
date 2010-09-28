require 'spec_helper'

describe WelcomeController do
  render_views
  
  it "should render a 'log out' link when logged in" do
    session[:cas_user] = "u1dhz6b0"
    get :index
    response.body.should include("Logga ut")
    
  end
end
