require "spec_helper"

describe DebtsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/debts" }.should route_to(:controller => "debts", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/debts/new" }.should route_to(:controller => "debts", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/debts/1" }.should route_to(:controller => "debts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/debts/1/edit" }.should route_to(:controller => "debts", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/debts" }.should route_to(:controller => "debts", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/debts/1" }.should route_to(:controller => "debts", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/debts/1" }.should route_to(:controller => "debts", :action => "destroy", :id => "1")
    end

  end
end
