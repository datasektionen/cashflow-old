require 'spec_helper'

describe PurchasesController do
  login_admin

  def mock_purchase(stubs = {})
    @mock_purchase ||= mock_model(Purchase, stubs).as_null_object
  end

  describe 'GET index' do
    xit 'assigns all purchases as @purchases' do
      Purchase.stub(:all).and_return { [mock_purchase] }
      get :index
      debugger
      assigns(:purchases).should eq([mock_purchase])
    end
  end

  describe 'GET show' do
    it 'assigns the requested purchase as @purchase' do
      purchase = mock_purchase
      Purchase.stub(:find).and_return { purchase }
      get :show, id: purchase.id
      assigns(:purchase).should == purchase
    end
  end

  describe 'GET new' do
    it 'assigns a new purchase as @purchase' do
      purchase = double('purchase',
                        :items => double('array', build: []),
                        :person= => nil,
                        :person_id= => nil
      )
      Purchase.stub(:new) { purchase }

      get :new
      assigns(:purchase).should be(purchase)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested purchase as @purchase' do
      Purchase.stub(:find).with('37') { mock_purchase }
      get :edit, id: '37'
      assigns(:purchase).should be(mock_purchase)
    end
  end

  describe 'POST create' do
    subject { mock_purchase(save: true) }

    before do
      Notifier.stub(:purchase_created).and_return(double(Mail).as_null_object)
      Purchase.stub(:new) { subject }
    end

    describe 'with valid params' do
      it 'assigns a newly created purchase as @purchase' do
        post :create, purchase: { 'these' => 'params' }
        assigns(:purchase).should be(subject)
      end

      it 'redirects to the created purchase' do
        post :create, purchase: {}
        response.should redirect_to(purchase_url(subject))
      end

      it "sends an email to the owner and to the cashier" do
        Notifier.should_receive(:purchase_created).with(subject)
        post :create, purchase: {}
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved purchase as @purchase' do
        Purchase.any_instance.stub(:save).and_return(false)
        Purchase.stub(:new).and_return(mock_purchase)
        purchase = mock_purchase
        post :create, purchase: { 'these' => 'params' }
        assigns(:purchase).should be(purchase)
      end

      it "re-renders the 'new' template" do
        Purchase.stub(:new) { mock_purchase(save: false) }
        post :create, purchase: {}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested purchase' do
        Purchase.should_receive(:find).with('37') { mock_purchase }
        mock_purchase.should_receive(:update_attributes).with('these' => 'params')
        put :update, id: '37', purchase: { 'these' => 'params' }
      end

      it 'assigns the requested purchase as @purchase' do
        Purchase.stub(:find) { mock_purchase(update_attributes: true) }
        put :update, id: '1'
        assigns(:purchase).should be(mock_purchase)
      end

      it 'redirects to the purchase' do
        Purchase.stub(:find) { mock_purchase(update_attributes: true) }
        put :update, id: '1'
        response.should redirect_to(purchase_url(mock_purchase))
      end
    end

    describe 'with invalid params' do
      it 'assigns the purchase as @purchase' do
        Purchase.stub(:find) { mock_purchase(update_attributes: false) }
        put :update, id: '1'
        assigns(:purchase).should be(mock_purchase)
      end

      it "re-renders the 'edit' template" do
        Purchase.stub(:find) { mock_purchase(update_attributes: false) }
        put :update, id: '1'
        response.should render_template('edit')
      end
    end
  end

  describe 'GET confirmed' do
    it 'calls only fetches payable purchases' do
      Purchase.should_receive(:payable_grouped_by_person).and_return([])

      get :confirmed
    end
  end

  describe 'POST pay_multiple' do
    it 'only fetches payable purchases' do
      Purchase.should_receive(:payable).and_return([])

      post :pay_multiple,  pay: {}
    end
  end

  describe "PUT confirm" do
    subject { mock_purchase({id: 4711, confirmed?: false })}

    before do
      Notifier.stub(:purchase_approved).and_return(double(Mail).as_null_object)
      Purchase.stub(:find).and_return(subject)
    end

    it "marks the purchase as confirmed" do
      subject.should_receive(:confirm!)
      put :confirm, id: subject.id
    end

    it "sends a confirmation email" do
      subject.stub(:confirmed?).and_return(true)
      Notifier.should_receive(:purchase_approved).with(subject)
      put :confirm, id: subject.id
    end
  end

  describe "PUT pay" do
    subject { mock_purchase({ id: 4711, paid?: false })}

    before do
      Notifier.stub(:purchase_paid).and_return(double(Mail).as_null_object)
      Purchase.stub(:find).and_return(subject)
    end

    it "marks the purchase as paid" do
      subject.should_receive(:pay!)
      put :pay, id: subject.id
    end

    it "sends an email to the owner of the purchase" do
      subject.stub(:paid?).and_return(true)
      Notifier.should_receive(:purchase_paid).with(subject)
      put :pay, id: subject.id
    end
  end

  describe "PUT keep" do
    subject { mock_purchase({ id: 4711, bookkept?: false })}

    before do
      Purchase.stub(:find).and_return(subject)
    end

    it "marks the purchase as bookkept" do
      Mage::Voucher.any_instance.stub(:push).and_return(true)
      subject.should_receive(:keep!)
      put :keep, id: subject.id
    end

    it "pushes the purchase to MAGE" do
      subject.stub(:bookkept?) { true }
      voucher = double(Mage::Voucher).as_null_object
      Mage::Voucher.stub(:from_purchase).and_return(voucher)
      Mage::Voucher.should_receive(:from_purchase).with(subject)
      voucher.should_receive(:push)
      put :keep, id: subject.id
    end
  end

  describe "PUT cancel" do
    subject { mock_purchase({ id: 4711, cancelled?: false })}

    before do
      Notifier.stub(:purchase_denied).and_return(double(Mail).as_null_object)
      Purchase.stub(:find).and_return(subject)
    end

    it "marks the purchase as cancelled" do
      subject.should_receive(:cancel!)
      put :cancel, id: subject.id
    end

    it "sends an email notification to the owner" do
      subject.stub(:cancelled?).and_return(true)
      Notifier.should_receive(:purchase_denied).with(subject)
      put :cancel, id: subject.id
    end
  end
end
