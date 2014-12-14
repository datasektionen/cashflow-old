require 'spec_helper'

describe 'people/new.html.haml' do
  before(:each) do
    assign(:person, stub_model(Person).as_new_record)
    @controller.stub(:current_user).and_return { stub_model(Person) }
  end

  it 'renders new person form' do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select 'form', action: people_path, method: 'post' do
    end
  end
end
