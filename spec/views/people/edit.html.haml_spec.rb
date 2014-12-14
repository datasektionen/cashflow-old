require 'spec_helper'

describe 'people/edit.html.haml' do
  before(:each) do
    @person = assign(:person, stub_model(Person,
                                         :new_record? => false
    ))
    @controller.stub(:current_user).and_return { stub_model(Person) }
  end

  it 'renders the edit person form' do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select 'form', action: person_path(@person), method: 'post' do
    end
  end
end
