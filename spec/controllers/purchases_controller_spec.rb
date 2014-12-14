require 'spec_helper'

describe PurchasesController do
  login_admin

  def mock_purchase(stubs = {})
    @mock_person ||= mock_model(Purchase, stubs).as_null_object
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
    describe 'with valid params' do
      it 'assigns a newly created purchase as @purchase' do
        Purchase.any_instance.stub(:save).and_return(true)
        Purchase.stub(:new) { mock_purchase(save: true) }
        post :create, purchase: { 'these' => 'params' }
        assigns(:purchase).should be(mock_purchase)
      end

      it 'redirects to the created purchase' do
        Purchase.stub(:new) { mock_purchase(save: true) }
        post :create, purchase: {}
        response.should redirect_to(purchase_url(mock_purchase))
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

  describe 'DELETE destroy' do
    it 'destroys the requested purchase' do
      Purchase.should_receive(:find).with('37') { mock_purchase }
      mock_purchase.should_not_receive(:destroy)
      delete :destroy, id: '37'
    end

    it 'redirects to the purchases list' do
      Purchase.stub(:find) { mock_purchase }
      delete :destroy, id: '1'
      response.should redirect_to(purchases_url)
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
end
