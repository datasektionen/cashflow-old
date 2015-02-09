require "spec_helper"

describe BudgetPostsController do
  login_admin

  let(:default_params) { { locale: "sv" } }

  # This should return the minimal set of attributes required to create a valid
  # BudgetPost. As you add validations to BudgetPost, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { business_unit_id: 1, name: "budgetpost", mage_arrangement_number: 1 }
  end

  def mock_budget_post(extra_attributes = {})
    double("budget_post", valid_attributes.merge(extra_attributes))
  end

  def stub_find
    @budget_post = mock_budget_post(id: 37)
    allow(BudgetPost).to receive(:find).and_return(@budget_post)
  end

  def stub_save
    @budget_post = mock_budget_post(id: 37)
    allow(BudgetPost).to receive(:save).and_return(@budget_post)
  end

  def stub_create
    @budget_post = mock_model(BudgetPost)
    allow(BudgetPost).to receive(:new).and_return(@budget_post)
    allow(@budget_post).to receive(:save).and_return(true)
  end

  context "GET actions" do
    describe "GET index" do
      it "assigns all budget_posts as @budget_posts" do
        budget_post = double("budget_post")
        # INFO: This doesn't really belong here,
        # but is needed because of broken SRP in the controller
        allow(BudgetRow).to receive(:create_rows_if_not_exists)
        allow(BudgetPost).to receive(:all).and_return([budget_post])
        get :index
        expect(assigns(:budget_posts)).to eq([budget_post])
      end
    end

    describe "GET show" do
      it "assigns the requested budget_post as @budget_post" do
        stub_find
        get :show, id: @budget_post.id.to_s
        expect(assigns(:budget_post)).to eq(@budget_post)
      end
    end

    describe "GET new" do
      it "assigns a new budget_post as @budget_post" do
        get :new
        expect(assigns(:budget_post)).to be_a_new(BudgetPost)
      end
    end

    describe "GET edit" do
      it "assigns the requested budget_post as @budget_post" do
        stub_find
        get :edit, id: @budget_post.id.to_s
        expect(assigns(:budget_post)).to eq(@budget_post)
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BudgetPost" do
        expect do
          post :create, budget_post: valid_attributes
        end.to change(BudgetPost, :count).by(1)
      end

      it "assigns a newly created budget_post as @budget_post" do
        post :create, budget_post: valid_attributes
        expect(assigns(:budget_post)).to be_a(BudgetPost)
        expect(assigns(:budget_post)).to be_persisted
      end

      it "redirects to the created budget_post" do
        stub_create
        post :create, budget_post: valid_attributes
        expect(response).to redirect_to(budget_post_path(@budget_post.id))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved budget_post as @budget_post" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(BudgetPost).to receive(:save).and_return(false)
        post :create, budget_post: {}
        expect(assigns(:budget_post)).to be_a_new(BudgetPost)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(BudgetPost).to receive(:save).and_return(false)
        post :create, budget_post: {}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      stub_find
    end

    describe "with valid params" do
      it "updates the requested budget_post" do
        expect(@budget_post).to receive(:update_attributes).
          with("these" => "params").
          and_return(true)
        put :update, id: @budget_post.id, budget_post: { "these" => "params" }
      end

      it "assigns the requested budget_post as @budget_post" do
        expect(@budget_post).to receive(:update_attributes).and_return(true)
        put :update, id: @budget_post.id, budget_post: valid_attributes
        expect(assigns(:budget_post)).to eq(@budget_post)
      end

      it "redirects to the budget_post" do
        expect(@budget_post).to receive(:update_attributes).and_return(true)
        put :update, id: @budget_post.id, budget_post: valid_attributes
        expect(response).to redirect_to(budget_post_path(@budget_post))
      end
    end

    describe "with invalid params" do
      it "assigns the budget_post as @budget_post" do
        expect(@budget_post).to receive(:update_attributes).and_return(false)

        put :update, id: @budget_post.id.to_s, budget_post: {}
        expect(assigns(:budget_post)).to eq(@budget_post)
      end

      it "re-renders the 'edit' template" do
        expect(@budget_post).to receive(:update_attributes).and_return(false)

        put :update, id: @budget_post.id.to_s, budget_post: {}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @budget_post = create(:budget_post, valid_attributes)
    end

    it "destroys the requested budget_post" do
      expect do
        delete :destroy, id: @budget_post.id.to_s
      end.to change(BudgetPost, :count).by(-1)
    end

    it "redirects to the budget_posts list" do
      delete :destroy, id: @budget_post.id.to_s
      expect(response).to redirect_to(budget_posts_url)
    end
  end
end
