require 'spec_helper'

describe Purchase do
  before(:all) do
    @person = Factory :person
    PaperTrail.whodunnit = @person.id.to_s
  end
  
  before(:each) do
    stub_request(:post, "#{Sunspot.config.solr.url}/update?wt=ruby").to_return(status: 200, body: '')
    @purchase = Factory :purchase
  end
  
  after(:each) do
    @purchase.destroy
    @purchase.person.destroy if @purchase.person
  end

  it "should be invalid without an owner" do
    @purchase.person = nil
    @purchase.should_not be_valid
  end

  it "should not ever change owner" do
    new_person = Factory :person
    @purchase.should be_valid

    @purchase.person = new_person
    @purchase.save.should be_true
    @purchase.reload.person.should_not ==(new_person)

    @purchase.update_attributes(:person_id => new_person.id)
    @purchase.save.should be_true
    @purchase.reload.person.should_not ==(new_person)
  end

  it "should be invalid without a description" do
    @purchase.description = nil
    @purchase.should be_invalid
    @purchase.description = ""
    @purchase.should be_invalid
  end

  it "should be created by someone" do
    @purchase.originator.should_not be_blank
  end

  it "should have a default workflow_state of \"new\"" do
    @purchase.workflow_state.should == "new"
  end

  it "should be purchased at some date" do
    @purchase.purchased_at.should_not be_blank
    @purchase.purchased_at = nil
    @purchase.should_not be_valid
    @purchase.errors[:purchased_at].should_not be_empty
  end
  
  it "should not be purchased in the future" do
    @purchase.purchased_at.should <= Date.today
    @purchase.purchased_at = Date.today + 1
    @purchase.should be_invalid
    @purchase.errors[:purchased_at].should_not be_empty
  end
  
  %w[new edited].each do |state|
    it "should be cancellable when #{state}" do
      @purchase.update_attribute(:workflow_state, state)
      lambda {@purchase.cancel!}.should_not raise_error
    end
  end
  
  %w[new confirmed].each do |state|
    it "should be editable when #{state}" do
      @purchase.update_attribute(:workflow_state, state)
      lambda {@purchase.edit!}.should_not raise_error
    end
  end
  
  %w[new edited].each do |state|
    it "should be confirmable when #{state}" do
      @purchase.update_attribute(:workflow_state, state)
      lambda {@purchase.confirm!}.should_not raise_error
    end
  end
  
  %w[confirmed paid].each do |state|
    it "should be bookkeepable when #{state}" do
      @purchase.update_attribute(:workflow_state, state)
      lambda {@purchase.keep!}.should_not raise_error
    end
  end
  
  %w[confirmed bookkept].each do |state|
    it "should be payable when #{state}" do
      @purchase.update_attribute(:workflow_state, state)
      lambda {@purchase.pay!}.should_not raise_error
    end
  end
  
  it "should be finalized when both paid and bookkept (in any order)" do
    @purchase.update_attribute(:workflow_state, "confirmed")
    lambda {@purchase.pay!}.should_not raise_error
    lambda {@purchase.keep!}.should_not raise_error
    @purchase.should be_finalized
    
    @purchase.update_attribute(:workflow_state, "confirmed")
    lambda {@purchase.keep!}.should_not raise_error
    lambda {@purchase.pay!}.should_not raise_error
    @purchase.should be_finalized
  end
  
  describe "" do
    %w[paid bookkept finalized confirmed].each do |state|
      before(:each) do
        @purchase.update_attribute(:workflow_state, state)
      end

      it "should not be cancellable when #{state}" do
        lambda {@purchase.cancel!}.should raise_error
      end

      it "should have confirmed_by when #{state}" do
        @purchase.confirmed_by.should_not be_nil
      end
    end
  end

  %w[cancelled finalized].each do |state|
    %w[confirm pay edit bookkeep].each do |action|
      it "should throw exception on ##{action}! when #{state}" do
        @purchase.update_attribute(:workflow_state, state)
        lambda {@purchase.send("#{action}!")}.should raise_error
      end
    end
  end

  it "should not be editable once finalized" do
    @purchase.update_attribute(:workflow_state, "finalized")
    @purchase.save.should be_false
  end
  
  it "should cascade delete its related purchase items" do
    @purchase.items.should be_empty
    pi = Factory.build(:purchase_item)
    pi.purchase = @purchase
    pi.save

    item = @purchase.reload.items.first
    
    item.should_not be_nil
    
    item_id = item.id
    purchase_id = @purchase.id
    
    @purchase.destroy
    Purchase.exists?(:id => purchase_id).should be_false
    PurchaseItem.exists?(:id => item_id).should be_false
  end

  it "should generate a slug before being saved" do
    @purchase.slug = ''
    @purchase.should be_valid
    @purchase.slug.should_not be_blank
  end

  it "should update the generated slug properly after being saved" do
    @purchase.save
    @purchase.slug.should_not be_blank
    @purchase.slug.should =~ /-#{@purchase.id}$/
  end

  describe ".payable" do
    before(:all) do
      stub_request(:post, "http://localhost:8981/solr/update?wt=ruby").to_return(:status => 200, :body => "", :headers => {})
      @purchases = {
        :new => Factory(:purchase),
        :confirmed => Factory(:purchase, :workflow_state => 'confirmed'),
        :edited => Factory(:purchase, :workflow_state => 'edited'),
        :bookkept => Factory(:purchase, :workflow_state => 'bookkept'),
        :paid => Factory(:purchase, :workflow_state => 'paid'),
        :finalized => Factory(:purchase)
      }

      @purchases[:finalized].update_attribute(:workflow_state, 'finalized')

    end

    %w[confirmed bookkept].each do |state|
      it "should include #{state} purchase" do
        Purchase.payable.should include(@purchases[state.to_sym])
      end
    end

    %w[new edited paid finalized].each do |state|
      it "should include #{state} purchase" do
        Purchase.payable.should_not include(@purchases[state.to_sym])
      end
    end

    after(:all) do
      stub_request(:post, "http://localhost:8981/solr/update?wt=ruby").to_return(:status => 200, :body => "", :headers => {})
      @purchases.values.map(&:destroy)
    end
  end

  describe ".payable_grouped_by_person" do
    pending("write some tests")
  end

  describe ".pay_payable_by!" do
    pending("write some tests")
  end
end
