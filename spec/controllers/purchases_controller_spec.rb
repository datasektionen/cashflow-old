require 'spec_helper'

describe PurchasesController do
  render_views
  login_admin

  def mock_purchase(stubs={})
    (@mock_purchase ||= mock_model(Purchase).as_null_object).tap do |purchase|
      purchase.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    xit "assigns all purchases as @purchases" do
      Purchase.stub(:all).and_return { [mock_purchase] }
      get :index
      assigns(:purchases).should eq([mock_purchase])
    end
  end

  describe "GET show" do
    it "assigns the requested purchase as @purchase" do
      purchase = Factory(:purchase)
      get :show, :id => purchase.id
      assigns(:purchase).should == purchase
    end
  end

  describe "GET new" do
    xit "assigns a new purchase as @purchase" do
      Purchase.stub(:new) { mock_purchase }
      get :new
      assigns(:purchase).should be(mock_purchase)
    end
  end

  describe "GET edit" do
    xit "assigns the requested purchase as @purchase" do
      Purchase.stub(:find).with("37") { mock_purchase }
      get :edit, :id => "37"
      assigns(:purchase).should be(mock_purchase)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created purchase as @purchase" do
        Purchase.stub(:new).with({'these' => 'params'}) { mock_purchase(:save => true) }
        post :create, :purchase => {'these' => 'params'}
        assigns(:purchase).should be(mock_purchase)
      end

      it "redirects to the created purchase" do
        Purchase.stub(:new) { mock_purchase(:save => true) }
        post :create, :purchase => {}
        response.should redirect_to(purchase_url(mock_purchase))
      end
    end

    describe "with invalid params" do
      xit "assigns a newly created but unsaved purchase as @purchase" do
        Purchase.stub(:new).with({'these' => 'params'}) { mock_purchase(:save => false) }
        post :create, :purchase => {'these' => 'params'}
        assigns(:purchase).should be(mock_purchase)
      end

      xit "re-renders the 'new' template" do
        Purchase.stub(:new) { mock_purchase(:save => false) }
        post :create, :purchase => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      xit "updates the requested purchase" do
        Purchase.should_receive(:find).with("37") { mock_purchase }
        mock_purchase.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :purchase => {'these' => 'params'}
      end

      it "assigns the requested purchase as @purchase" do
        Purchase.stub(:find) { mock_purchase(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:purchase).should be(mock_purchase)
      end

      it "redirects to the purchase" do
        Purchase.stub(:find) { mock_purchase(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(purchase_url(mock_purchase))
      end
    end

    describe "with invalid params" do
      xit "assigns the purchase as @purchase" do
        Purchase.stub(:find) { mock_purchase(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:purchase).should be(mock_purchase)
      end

      xit "re-renders the 'edit' template" do
        Purchase.stub(:find) { mock_purchase(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested purchase" do
      Purchase.should_receive(:find).with("37") { mock_purchase }
      mock_purchase.should_not_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the purchases list" do
      Purchase.stub(:find) { mock_purchase }
      delete :destroy, :id => "1"
      response.should redirect_to(purchases_url)
    end
  end

end
