require 'spec_helper'

describe "purchases/show.html.haml" do
  before(:each) do
    @person = assign(:current_user, stub_model(Person, :id => 37))
    PaperTrail.whodunnit = "37"

    @purchase = stub_model(Purchase, :person => @person, :purchased_at => Time.now, :total => 123, :workflow_state => "Ny", :budget_post => stub_model(BudgetPost, :to_s => "budget_post"), :updated_at => Time.now, :last_updated_by => @person, :to_s => "purchase")
    @purchase.stub(:state_history).and_return { [OpenStruct.new(:originator => @person, :workflow_state => "Ny", :version_date => Time.now)] }
    assign(:purchase, @purchase)
  end

  it "renders attributes in <p>" do
    render
  end
end
