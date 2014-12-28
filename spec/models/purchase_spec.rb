require 'spec_helper'

describe Purchase do

  before(:all) do
    @person = Factory :person
  end

  before(:each) do
    Purchase.paper_trail_on!
    PaperTrail.enabled = true
    PaperTrail.whodunnit = @person.id.to_s
    @purchase = Factory :purchase
  end

  subject { @purchase }

  it "should be versioned" do
    subject.should be_versioned
  end

  it 'should be invalid without an owner' do
    subject.person = nil
    subject.should_not be_valid
  end

  it 'should not ever change owner' do
    new_person = Factory :person
    subject.should be_valid

    subject.person = new_person
    subject.save.should be_true
    subject.reload.person.should_not == (new_person)

    subject.update_attributes(person_id: new_person.id)
    subject.save.should be_true
    subject.reload.person.should_not == (new_person)
  end

  it 'should be invalid without a description' do
    subject.description = nil
    subject.should be_invalid
    subject.description = ''
    subject.should be_invalid
  end

  it 'should be created by someone' do
    subject.originator.should_not be_blank
  end

  it "should have a default workflow_state of \"new\"" do
    subject.workflow_state.should == 'new'
  end

  it 'should be purchased at some date' do
    subject.purchased_on.should_not be_blank
    subject.purchased_on = nil
    subject.should_not be_valid
    subject.errors[:purchased_on].should_not be_empty
  end

  it 'should not be purchased in the future' do
    subject.purchased_on.should be <= Date.today
    subject.purchased_on = Date.today + 1
    subject.should be_invalid
    subject.errors[:purchased_on].should_not be_empty
  end

  %w(new edited).each do |state|
    it "should be cancellable when #{state}" do
      subject.update_attribute(:workflow_state, state)
      lambda { subject.cancel! }.should_not raise_error
    end
  end

  %w(new confirmed).each do |state|
    it "should be editable when #{state}" do
      subject.update_attribute(:workflow_state, state)
      lambda { subject.edit! }.should_not raise_error
    end
  end

  %w(new edited).each do |state|
    it "should be confirmable when #{state}" do
      subject.update_attribute(:workflow_state, state)
      lambda { subject.confirm! }.should_not raise_error
    end
  end

  %w(confirmed paid).each do |state|
    it "should be bookkeepable when #{state}" do
      subject.update_attribute(:workflow_state, state)
      lambda { subject.keep! }.should_not raise_error
    end
  end

  %w(confirmed bookkept).each do |state|
    it "should be payable when #{state}" do
      subject.update_attribute(:workflow_state, state)
      lambda { subject.pay! }.should_not raise_error
    end
  end

  it 'should be finalized when both paid and bookkept (in any order)' do
    subject.update_attribute(:workflow_state, 'confirmed')
    lambda { subject.pay! }.should_not raise_error
    lambda { subject.keep! }.should_not raise_error
    subject.should be_finalized

    subject.update_attribute(:workflow_state, 'confirmed')
    lambda { subject.keep! }.should_not raise_error
    lambda { subject.pay! }.should_not raise_error
    subject.should be_finalized
  end

  describe '' do
    %w(paid bookkept finalized confirmed).each do |state|
      before(:each) do
        subject.update_attribute(:workflow_state, state)
      end

      it "should not be cancellable when #{state}" do
        lambda { subject.cancel! }.should raise_error
      end

      it "should have confirmed_by when #{state}" do
        subject.confirmed_by.should_not be_nil
      end
    end
  end

  %w(cancelled finalized).each do |state|
    %w(confirm pay edit bookkeep).each do |action|
      it "should throw exception on ##{action}! when #{state}" do
        subject.update_attribute(:workflow_state, state)
        lambda { subject.send("#{action}!") }.should raise_error
      end
    end
  end

  it 'should not be editable once finalized' do
    subject.update_attribute(:workflow_state, 'finalized')
    subject.save.should be_false
  end

  it 'should cascade delete its related purchase items' do
    subject.items.should be_empty
    pi = Factory.build(:purchase_item)
    pi.purchase = subject
    pi.save

    item = subject.reload.items.first

    item.should_not be_nil

    item_id = item.id
    purchase_id = subject.id

    subject.destroy
    Purchase.exists?(id: purchase_id).should be_false
    PurchaseItem.exists?(id: item_id).should be_false
  end

  it 'should generate a slug before being saved' do
    subject.slug = ''
    subject.should be_valid
    subject.slug.should_not be_blank
  end

  it 'should update the generated slug properly after being saved' do
    subject.save
    subject.slug.should_not be_blank
    subject.slug.should =~ /-#{subject.id}$/
  end

  describe '.payable' do
    before(:all) do
      stub_request(:post, 'http://localhost:8981/solr/update?wt=ruby').to_return(status: 200, body: '', headers: {})
      @purchases = {
        new: Factory(:purchase),
        confirmed: Factory(:purchase, workflow_state: 'confirmed'),
        edited: Factory(:purchase, workflow_state: 'edited'),
        bookkept: Factory(:purchase, workflow_state: 'bookkept'),
        paid: Factory(:purchase, workflow_state: 'paid'),
        finalized: Factory(:purchase)
      }

      @purchases[:finalized].update_attribute(:workflow_state, 'finalized')
    end

    %w(confirmed bookkept).each do |state|
      it "should include #{state} purchase" do
        Purchase.payable.should include(@purchases[state.to_sym])
      end
    end

    %w(new edited paid finalized).each do |state|
      it "should include #{state} purchase" do
        Purchase.payable.should_not include(@purchases[state.to_sym])
      end
    end

    after(:all) do
      stub_request(:post, 'http://localhost:8981/solr/update?wt=ruby').to_return(status: 200, body: '', headers: {})
      @purchases.values.map(&:destroy)
    end
  end

  describe '.payable_grouped_by_person' do
    before(:all) do
      Purchase.delete_all
      @purchase_1 = Factory(:purchase, workflow_state: 'confirmed')
      @purchase_2 = Factory(:purchase, workflow_state: 'confirmed')
      @person_1 = @purchase_1.person
      @person_2 = @purchase_2.person
    end

    subject { Purchase.payable_grouped_by_person }

    it "keeps different people separate" do
      subject.keys.sort_by(&:id).should == [@person_1, @person_2]
    end

    it "sums the total payable amount per person" do
      p = Factory(:purchase, workflow_state: 'confirmed', person: @person_1)

      expected = {
        @person_1 => @purchase_1.total + p.total,
        @person_2 => @purchase_2.total
      }

      subject.should == expected
    end
  end

  describe '.pay_payable_by!' do
    pending('write some tests')
  end
end
