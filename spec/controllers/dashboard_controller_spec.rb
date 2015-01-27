require "spec_helper"

describe DashboardController do
  describe "GET index" do
    it "responds successfully" do
      get :index
      expect(response).to be_successful
    end
  end
end
