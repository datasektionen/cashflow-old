require 'spec_helper'
describe Mage::Base do
  it 'Setting and getting attributes should work' do
    b = Mage::Base.new(foo: 'bar')
    b.foo.should == 'bar'
    b.baz = 'derp'
    b.baz.should == 'derp'
    b.foo.should == 'bar'
    b.moo.should.nil?
    b.moo?.should == false
    b.baz?.should == true
  end
end
