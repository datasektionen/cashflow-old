require "spec_helper"

describe ProductTypesController do
  def mock_product_type(stubs = {})
    @mock_product_type ||= mock_model(ProductType).as_null_object
    @mock_product_type.tap do |product_type|
      stubs = stubs.reverse_merge(to_str: nil)
      stubs.each do |k, v|
        allow(product_type).to receive(k).and_return(v)
      end
    end
  end

  let(:default_params) { { locale: "sv" } }

  describe "When logged in as admin" do
    login_admin
    describe "GET index" do
      it "assigns all product_types as @product_types" do
        allow(ProductType).to receive(:all) { [mock_product_type] }
        get :index
        expect(assigns(:product_types)).to eq([mock_product_type])
      end
    end

    describe "GET show" do
      it "assigns the requested product_type as @product_type" do
        allow(ProductType).to receive(:find).with("37") { mock_product_type }
        get :show, id: "37"
        expect(assigns(:product_type)).to be(mock_product_type)
      end
    end

    describe "GET new" do
      it "assigns a new product_type as @product_type" do
        allow(ProductType).to receive(:new) { mock_product_type }
        get :new
        expect(assigns(:product_type)).to be(mock_product_type)
      end
    end

    describe "GET edit" do
      it "assigns the requested product_type as @product_type" do
        allow(ProductType).to receive(:find).with("37") { mock_product_type }
        get :edit, id: "37"
        expect(assigns(:product_type)).to be(mock_product_type)
      end
    end

    describe "POST create" do

      describe "with valid params" do

        before(:each) do
          allow(ProductType).to receive(:new).
                        with("these" => "params").
                        and_return(mock_product_type(save: true))
        end

        it "assigns a newly created product_type as @product_type" do
          post :create, product_type: { "these" => "params" }
          expect(assigns(:product_type)).to be(mock_product_type)
        end

        it "redirects to the created product_type" do
          post :create, product_type: { "these" => "params" }
          expect(response).to redirect_to(product_type_url(mock_product_type))
        end
      end

      describe "with invalid params" do

        before(:each) do
          allow(ProductType).to receive(:new).
                        with("these" => "params").
                        and_return(mock_product_type(save: false))
        end

        it "assigns a new but unsaved product_type as @product_type" do
          post :create, product_type: { "these" => "params" }
          expect(assigns(:product_type)).to be(mock_product_type)
        end

        it "re-renders the 'new' template" do
          post :create, product_type: { "these" => "params" }
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do

        before(:each) do
          allow(ProductType).to receive(:find).
                        and_return(mock_product_type(update_attributes: true))
        end

        it "updates the requested product_type" do
          expect(mock_product_type).to receive(:update_attributes).
                                        with("these" => "params")
          put :update, id: "37", product_type: { "these" => "params" }
        end

        it "assigns the requested product_type as @product_type" do
          put :update, id: "1"
          expect(assigns(:product_type)).to be(mock_product_type)
        end

        it "redirects to the product_type" do
          put :update, id: "1"
          expect(response).to redirect_to(product_type_url(mock_product_type))
        end
      end

      describe "with invalid params" do

        before(:each) do
          allow(ProductType).to receive(:find).
                        and_return(mock_product_type(update_attributes: false))
        end

        it "assigns the product_type as @product_type" do
          put :update, id: "1"
          expect(assigns(:product_type)).to be(mock_product_type)
        end

        it "re-renders the 'edit' template" do
          put :update, id: "1"
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested product_type" do
        expect(ProductType).to receive(:find).with("37") { mock_product_type }
        expect(mock_product_type).to receive(:destroy)
        delete :destroy, id: "37"
      end

      it "redirects to the product_types list" do
        allow(ProductType).to receive(:find) { mock_product_type }
        delete :destroy, id: "1"
        expect(response).to redirect_to(product_types_url)
      end
    end
  end
end
