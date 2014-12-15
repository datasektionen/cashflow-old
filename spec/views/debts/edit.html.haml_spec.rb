require 'spec_helper'

describe 'debts/edit.html.haml' do
  before(:each) do
    @debt = assign(:debt, stub_model(Debt,
                                     :new_record? => false
    ))
  end

  it 'renders the edit debt form' do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select 'form', action: debt_path(@debt), method: 'post'
  end
end
