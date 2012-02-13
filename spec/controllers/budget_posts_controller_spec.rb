require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe BudgetPostsController do
  login_admin

  # This should return the minimal set of attributes required to create a valid
  # BudgetPost. As you add validations to BudgetPost, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {business_unit_id: 1, name: 'budgetpost'}
  end

  def mock_budget_post(extra_attributes = {})
    double("budget_post", valid_attributes.merge(extra_attributes))
  end

  def stub_find
    @budget_post = mock_budget_post(id: 37)
    BudgetPost.stub(:find).and_return(@budget_post)
  end

  def stub_save
    @budget_post = mock_budget_post(id: 37)
    BudgetPost.stub(:save).and_return(@budget_post)
  end

  def stub_create
    @budget_post = mock_model(BudgetPost)
    BudgetPost.stub(:new).and_return(@budget_post)
    @budget_post.stub(:save).and_return(true)
  end

  context "GET actions" do
    describe "GET index" do
      it "assigns all budget_posts as @budget_posts" do
        budget_post = double("budget_post")
        BudgetRow.stub(:create_rows_if_not_exists) # INFO: This doesn't really belong here, but is needed because of broken SRP in the controller
        BudgetPost.stub(:all).and_return([budget_post])
        get :index
        assigns(:budget_posts).should eq([budget_post])
      end
    end

    describe "GET show" do
      it "assigns the requested budget_post as @budget_post" do
        stub_find
        get :show, :id => @budget_post.id.to_s
        assigns(:budget_post).should eq(@budget_post)
      end
    end

    describe "GET new" do
      it "assigns a new budget_post as @budget_post" do
        get :new
        assigns(:budget_post).should be_a_new(BudgetPost)
      end
    end

    describe "GET edit" do
      it "assigns the requested budget_post as @budget_post" do
        stub_find
        get :edit, :id => @budget_post.id.to_s
        assigns(:budget_post).should == @budget_post
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BudgetPost" do
        expect {
          post :create, :budget_post => valid_attributes
        }.to change(BudgetPost, :count).by(1)
      end

      it "assigns a newly created budget_post as @budget_post" do
        post :create, :budget_post => valid_attributes
        assigns(:budget_post).should be_a(BudgetPost)
        assigns(:budget_post).should be_persisted
      end

      it "redirects to the created budget_post" do
        stub_create
        post :create, :budget_post => valid_attributes
        response.should redirect_to(budget_post_path(@budget_post.id))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved budget_post as @budget_post" do
        # Trigger the behavior that occurs when invalid params are submitted
        BudgetPost.any_instance.stub(:save).and_return(false)
        post :create, :budget_post => {}
        assigns(:budget_post).should be_a_new(BudgetPost)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        BudgetPost.any_instance.stub(:save).and_return(false)
        post :create, :budget_post => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      stub_find
    end

    describe "with valid params" do
      it "updates the requested budget_post" do
        @budget_post.should_receive(:update_attributes).with({'these' => 'params'}).and_return(true)
        put :update, :id => @budget_post.id, :budget_post => {'these' => 'params'}
      end

      it "assigns the requested budget_post as @budget_post" do
        @budget_post.should_receive(:update_attributes).and_return(true)
        put :update, :id => @budget_post.id, :budget_post => valid_attributes
        assigns(:budget_post).should eq(@budget_post)
      end

      it "redirects to the budget_post" do
        @budget_post.should_receive(:update_attributes).and_return(true)
        put :update, :id => @budget_post.id, :budget_post => valid_attributes
        response.should redirect_to(budget_post_path(@budget_post))
      end
    end

    describe "with invalid params" do
      it "assigns the budget_post as @budget_post" do
        @budget_post.should_receive(:update_attributes).and_return(false)

        put :update, :id => @budget_post.id.to_s, :budget_post => {}
        assigns(:budget_post).should eq(@budget_post)
      end

      it "re-renders the 'edit' template" do
        @budget_post.should_receive(:update_attributes).and_return(false)
        
        put :update, :id => @budget_post.id.to_s, :budget_post => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @budget_post = Factory :budget_post, valid_attributes
    end

    it "destroys the requested budget_post" do
      expect {
        delete :destroy, :id => @budget_post.id.to_s
      }.to change(BudgetPost, :count).by(-1)
    end

    it "redirects to the budget_posts list" do
      delete :destroy, :id => @budget_post.id.to_s
      response.should redirect_to(budget_posts_url)
    end
  end

end
