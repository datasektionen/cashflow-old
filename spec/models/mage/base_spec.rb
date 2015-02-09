require "spec_helper"
describe Mage::Base do
  it "Setting and getting attributes should work" do
    b = Mage::Base.new(foo: "bar")
    expect(b.foo).to eq("bar")
    b.baz = "derp"
    expect(b.baz).to eq("derp")
    expect(b.foo).to eq("bar")
    expect(b.moo).to be_nil
    expect(b.moo?).to eq(false)
    expect(b.baz?).to eq(true)
  end
end
