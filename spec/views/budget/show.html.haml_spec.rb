require "spec_helper"

describe "budget/show.html.haml" do

  before(:each) do
    row = mock_model(BudgetRow, 
                     Factory(:budget_row).attributes.merge(
                       :budget_post => mock_model(BudgetPost, Factory(:budget_post).attributes),
                       :business_unit => mock_model(BusinessUnit),
                       :total => 0
                    ))
    assign(:budget_rows, [row])
    assign(:year, Time.now.year)
    @controller.stub(:can?).and_return { true }
    render
  end

  subject do
    rendered
  end

  it "renders a list of budget rows" do
    rendered.should =~ /table class='datatable' id='list'/
  end

  context "Year select form" do
    it "exists" do
      rendered.should =~ /year_select_form/
    end
    
    it "contains options" do
      html = Nokogiri::HTML(rendered)
      html.xpath('//select').children.should_not be_empty
    end
  end

  it { should =~ /#{I18n.t('edit_budget')}/ }
  it { should_not =~ /translation_missing/ }
end
