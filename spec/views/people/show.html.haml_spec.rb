require 'spec_helper'

describe 'people/show.html.haml' do
  before(:each) do
    @person = assign(:person, stub_model(Person))
  end

  it 'renders attributes in <p>' do
    render
  end
end
