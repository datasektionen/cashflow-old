require "spec_helper"

describe BudgetPostsController do
  describe "routing" do

    it "routes to #index" do
      get("/budget_posts").should route_to("budget_posts#index")
    end

    it "routes to #new" do
      get("/budget_posts/new").should route_to("budget_posts#new")
    end

    it "routes to #show" do
      get("/budget_posts/1").should route_to("budget_posts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/budget_posts/1/edit").should route_to("budget_posts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/budget_posts").should route_to("budget_posts#create")
    end

    it "routes to #update" do
      put("/budget_posts/1").should route_to("budget_posts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/budget_posts/1").should route_to("budget_posts#destroy", :id => "1")
    end

  end
end
