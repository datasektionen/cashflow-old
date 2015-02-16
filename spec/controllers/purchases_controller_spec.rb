require "spec_helper"

describe PurchasesController do
  login_admin

  def mock_purchase(stubs = {})
    stubs = stubs.reverse_merge(to_str: nil)
    @mock_purchase ||= mock_model(Purchase, stubs).as_null_object
  end

  describe "GET index" do
    xit "assigns all purchases as @purchases" do
      allow(Purchase).to receive(:all) { [mock_purchase] }
      get :index
      debugger
      expect(assigns(:purchases)).to eq([mock_purchase])
    end
  end

  describe "GET show" do
    it "assigns the requested purchase as @purchase" do
      purchase = mock_purchase
      allow(Purchase).to receive(:find) { purchase }
      get :show, id: purchase.id
      expect(assigns(:purchase)).to eq(purchase)
    end
  end

  describe "GET new" do
    it "assigns a new purchase as @purchase" do
      purchase = spy("purchase",
                        :items => double("array", build: []),
                        :person= => nil,
                        :person_id= => nil
      )
      allow(Purchase).to receive(:new) { purchase }

      get :new

      expect(assigns(:purchase)).to be(purchase)
    end
  end

  describe "GET edit" do
    it "assigns the requested purchase as @purchase" do
      allow(Purchase).to receive(:find).with("37") { mock_purchase }
      get :edit, id: "37"
      expect(assigns(:purchase)).to be(mock_purchase)
    end
  end

  describe "POST create" do
    subject { mock_purchase(save: true) }

    before do
      allow(Notifier).to receive(:purchase_created).
                          and_return(double(Mail).as_null_object)
      allow(Purchase).to receive(:new) { subject }
    end

    describe "with valid params" do
      it "assigns a newly created purchase as @purchase" do
        post :create, purchase: { description: "foo bar" }
        expect(assigns(:purchase)).to be(subject)
      end

      it "redirects to the created purchase" do
        post :create, purchase: { description: "foo bar" }
        expect(response).to redirect_to(purchase_path(subject))
      end

      it "sends an email to the owner and to the cashier" do
        expect(Notifier).to receive(:purchase_created).with(subject)
        post :create, purchase: { description: "foo bar" }
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved purchase as @purchase" do
        allow_any_instance_of(Purchase).to receive(:save).and_return(false)
        allow(Purchase).to receive(:new).and_return(mock_purchase)
        purchase = mock_purchase
        post :create, purchase: { description: "foo bar" }
        expect(assigns(:purchase)).to be(purchase)
      end

      it "re-renders the 'new' template" do
        allow(Purchase).to receive(:new) { mock_purchase(save: false) }
        post :create, purchase: { description: "foo bar" }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do

      before(:each) do
        expect(Purchase).to receive(:find).
                            with("37").
                            and_return(mock_purchase(update_attributes: true))
      end

      it "updates the requested purchase" do
        expect(mock_purchase).to receive(:update_attributes).
                                  with("description" => "foo bar")
        put :update, id: "37", purchase: { "description" => "foo bar" }
      end

      it "assigns the requested purchase as @purchase" do
        put :update, id: "37", purchase: { description: "foo bar" }
        expect(assigns(:purchase)).to be(mock_purchase)
      end

      it "redirects to the purchase" do
        put :update, id: "37", purchase: { description: "foo bar" }
        expect(response).to redirect_to(purchase_path(mock_purchase))
      end
    end

    describe "with invalid params" do

      before(:each) do
        allow(Purchase).to receive(:find).
                            and_return(mock_purchase(update_attributes: false))
      end

      it "assigns the purchase as @purchase" do
        put :update, id: "37", purchase: { description: "foo bar" }
        expect(assigns(:purchase)).to be(mock_purchase)
      end

      it "re-renders the 'edit' template" do
        put :update, id: "37", purchase: { description: "foo bar" }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "GET confirmed" do
    it "calls only fetches payable purchases" do
      expect(Purchase).to receive(:payable_grouped_by_person).and_return([])

      get :confirmed
    end
  end

  describe "POST pay_multiple" do
    it "only fetches payable purchases" do
      expect(Purchase).to receive(:payable).and_return([])

      post :pay_multiple,  pay: {}
    end
  end

  describe "PUT confirm" do
    subject { mock_purchase({id: 4711, confirmed?: false })}

    before do
      allow(Notifier).to receive(:purchase_approved).
                          and_return(double(Mail).as_null_object)
      allow(Purchase).to receive(:find).and_return(subject)
    end

    it "marks the purchase as confirmed" do
      expect(subject).to receive(:confirm!)
      put :confirm, id: subject.id
    end

    it "sends a confirmation email" do
      allow(subject).to receive(:confirmed?).and_return(true)
      expect(Notifier).to receive(:purchase_approved).with(subject)
      put :confirm, id: subject.id
    end
  end

  describe "PUT pay" do
    subject { mock_purchase({ id: 4711, paid?: false })}

    before do
      allow(Notifier).to receive(:purchase_paid).
                          and_return(double(Mail).as_null_object)
      allow(Purchase).to receive(:find).and_return(subject)
    end

    it "marks the purchase as paid" do
      expect(subject).to receive(:pay!)
      put :pay, id: subject.id
    end

    it "sends an email to the owner of the purchase" do
      allow(subject).to receive(:paid?).and_return(true)
      expect(Notifier).to receive(:purchase_paid).with(subject)
      put :pay, id: subject.id
    end
  end

  describe "PUT keep" do
    subject { mock_purchase({ id: 4711, bookkept?: false })}

    before do
      allow(Purchase).to receive(:find).and_return(subject)
    end

    it "marks the purchase as bookkept" do
      allow_any_instance_of(Mage::Voucher).to receive(:push).and_return(true)
      expect(subject).to receive(:keep!)
      put :keep, id: subject.id
    end

    it "pushes the purchase to MAGE" do
      allow(subject).to receive(:bookkept?) { true }
      voucher = double(Mage::Voucher).as_null_object
      allow(Mage::Voucher).to receive(:from_purchase).and_return(voucher)
      expect(Mage::Voucher).to receive(:from_purchase).with(subject)
      expect(voucher).to receive(:push)
      put :keep, id: subject.id
    end
  end

  describe "PUT cancel" do
    subject { mock_purchase({ id: 4711, cancelled?: false })}

    before do
      allow(Notifier).to receive(:purchase_denied).
                          and_return(double(Mail).as_null_object)
      allow(Purchase).to receive(:find).and_return(subject)
    end

    it "marks the purchase as cancelled" do
      expect(subject).to receive(:cancel!)
      put :cancel, id: subject.id
    end

    it "sends an email notification to the owner" do
      allow(subject).to receive(:cancelled?).and_return(true)
      expect(Notifier).to receive(:purchase_denied).with(subject)
      put :cancel, id: subject.id
    end
  end
end
