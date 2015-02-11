require "spec_helper"

RSpec.describe Purchase do

  before(:all) do
    @person = create(:person)
  end

  before(:each) do
    Purchase.paper_trail_on!
    PaperTrail.enabled = true
    PaperTrail.whodunnit = @person.id.to_s
    @purchase = create(:purchase)
  end

  subject { @purchase }

  it "should be versioned" do
    expect(subject).to be_versioned
  end

  it "should be invalid without an owner" do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it "should not ever change owner" do
    new_person = create(:person)
    expect(subject).to be_valid

    subject.person = new_person
    expect(subject.save).to be_truthy
    expect(subject.reload.person).not_to eq(new_person)

    subject.update_attributes(person_id: new_person.id)
    expect(subject.save).to be_truthy
    expect(subject.reload.person).not_to eq(new_person)
  end

  it "should be invalid without a description" do
    subject.description = nil
    expect(subject).to be_invalid
    subject.description = ""
    expect(subject).to be_invalid
  end

  it "should be created by someone" do
    expect(subject.originator).not_to be_blank
  end

  it "should have a default workflow_state of \"new\"" do
    expect(subject.workflow_state).to eq("new")
  end

  it "should be purchased at some date" do
    expect(subject.purchased_on).not_to be_blank
    subject.purchased_on = nil
    expect(subject).not_to be_valid
    expect(subject.errors[:purchased_on]).not_to be_empty
  end

  it "should not be purchased in the future" do
    expect(subject.purchased_on).to be <= Date.today
    subject.purchased_on = Date.today + 1
    expect(subject).to be_invalid
    expect(subject.errors[:purchased_on]).not_to be_empty
  end

  %w(new edited).each do |state|
    it "should be cancellable when #{state}" do
      subject.update_attribute(:workflow_state, state)
      expect { subject.cancel! }.not_to raise_error
    end
  end

  %w(new confirmed).each do |state|
    it "should be editable when #{state}" do
      subject.update_attribute(:workflow_state, state)
      expect { subject.edit! }.not_to raise_error
    end
  end

  %w(new edited).each do |state|
    it "should be confirmable when #{state}" do
      subject.update_attribute(:workflow_state, state)
      expect { subject.confirm! }.not_to raise_error
    end
  end

  %w(confirmed paid).each do |state|
    it "should be bookkeepable when #{state}" do
      subject.update_attribute(:workflow_state, state)
      expect { subject.keep! }.not_to raise_error
    end
  end

  %w(confirmed bookkept).each do |state|
    it "should be payable when #{state}" do
      subject.update_attribute(:workflow_state, state)
      expect { subject.pay! }.not_to raise_error
    end
  end

  it "should be finalized when both paid and bookkept (in any order)" do
    subject.update_attribute(:workflow_state, "confirmed")
    expect { subject.pay! }.not_to raise_error
    expect { subject.keep! }.not_to raise_error
    expect(subject).to be_finalized

    subject.update_attribute(:workflow_state, "confirmed")
    expect { subject.keep! }.not_to raise_error
    expect { subject.pay! }.not_to raise_error
    expect(subject).to be_finalized
  end

  describe "" do
    %w(paid bookkept finalized confirmed).each do |state|
      before(:each) do
        subject.update_attribute(:workflow_state, state)
      end

      it "should not be cancellable when #{state}" do
        expect { subject.cancel! }.to raise_error
      end

      it "should have confirmed_by when #{state}" do
        expect(subject.confirmed_by).not_to be_nil
      end
    end
  end

  %w(cancelled finalized).each do |state|
    %w(confirm pay edit bookkeep).each do |action|
      it "should throw exception on ##{action}! when #{state}" do
        subject.update_attribute(:workflow_state, state)
        expect { subject.send("#{action}!") }.to raise_error
      end
    end
  end

  it "should not be editable once finalized" do
    subject.update_attribute(:workflow_state, "finalized")
    expect(subject.save).to be_falsey
  end

  it "should cascade delete its related purchase items" do
    expect(subject.items).to be_empty
    pi = build(:purchase_item)
    pi.purchase = subject
    pi.save

    item = subject.reload.items.first

    expect(item).not_to be_nil

    item_id = item.id
    purchase_id = subject.id

    subject.destroy
    expect(Purchase.exists?(id: purchase_id)).to be_falsey
    expect(PurchaseItem.exists?(id: item_id)).to be_falsey
  end

  it "should generate a slug before being saved" do
    subject.slug = ""
    expect(subject).to be_valid
    expect(subject.slug).not_to be_blank
  end

  it "should update the generated slug properly after being saved" do
    subject.save
    expect(subject.slug).not_to be_blank
    expect(subject.slug).to match(/-#{subject.id}$/)
  end

  describe ".payable" do
    before(:all) do
      @purchases = {
        new: create(:purchase),
        confirmed: create(:purchase, workflow_state: "confirmed"),
        edited: create(:purchase, workflow_state: "edited"),
        bookkept: create(:purchase, workflow_state: "bookkept"),
        paid: create(:purchase, workflow_state: "paid"),
        finalized: create(:purchase)
      }

      @purchases[:finalized].update_attribute(:workflow_state, "finalized")
    end

    %w(confirmed bookkept).each do |state|
      it "should include #{state} purchase" do
        expect(Purchase.payable).to include(@purchases[state.to_sym])
      end
    end

    %w(new edited paid finalized).each do |state|
      it "should include #{state} purchase" do
        expect(Purchase.payable).not_to include(@purchases[state.to_sym])
      end
    end

    after(:all) do
      @purchases.values.map(&:destroy)
    end
  end

  describe ".payable_grouped_by_person" do
    before(:all) do
      Purchase.delete_all
      @purchase_1 = create(:purchase, workflow_state: "confirmed")
      @purchase_2 = create(:purchase, workflow_state: "confirmed")
      @person_1 = @purchase_1.person
      @person_2 = @purchase_2.person
    end

    subject { Purchase.payable_grouped_by_person }

    it "keeps different people separate" do
      expect(subject.keys.sort_by(&:id)).to eq([@person_1, @person_2])
    end

    it "sums the total payable amount per person" do
      p = create(:purchase, workflow_state: "confirmed", person: @person_1)

      expected = {
        @person_1 => @purchase_1.total + p.total,
        @person_2 => @purchase_2.total
      }

      expect(subject).to eq(expected)
    end
  end

  describe ".pay_payable_by!" do
    skip("write some tests")
  end
end
