require 'spec_helper'

describe PeopleController do
  render_views

  def mock_person(stubs={})
    (@mock_person ||= mock_model(Person).as_null_object).tap do |person|
      person.stub(stubs) unless stubs.empty?
    end
  end

  describe "unauthenticated user" do
    it "should be redirected to the login page" do
      get :index
      response.should redirect_to(new_person_session_url)
    end
  end
  
  describe "authenticated user" do
    login_admin
    describe "GET index" do
      it "assigns all people as @people" do
        Person.stub(:all) { [mock_person] }
        get :index
        assigns(:people).should eq([mock_person])
      end
    end
  
    describe "GET show" do
      it "assigns the requested person as @person" do
        Person.stub(:find).with("37") { mock_person }
        get :show, :id => "37"
        assigns(:person).should be(mock_person)
      end
    end
  
    describe "GET new" do
      xit "assigns a new person as @person" do
        Person.stub(:new) { mock_person }
        get :new
        assigns(:person).should be(mock_person)
      end
    end
  
    describe "GET edit" do
      xit "assigns the requested person as @person" do
        Person.stub(:find).with("37") { mock_person }
        get :edit, :id => "37"
        assigns(:person).should be(mock_person)
      end
    end
  
    describe "POST create" do
  
      describe "with valid params" do
        xit "assigns a newly created person as @person" do
          Person.stub(:new).with({'these' => 'params'}) { mock_person(:save => true) }
          post :create, :person => {'these' => 'params'}
          assigns(:person).should be(mock_person)
        end
  
        xit "redirects to the created person" do
          Person.stub(:new) { mock_person(:save => true) }
          post :create, :person => {}
          response.should redirect_to(person_url(mock_person))
        end
      end
  
      describe "with invalid params" do
        xit "assigns a newly created but unsaved person as @person" do
          Person.stub(:new).with({'these' => 'params'}) { mock_person(:save => false) }
          post :create, :person => {'these' => 'params'}
          assigns(:person).should be(mock_person)
        end
  
        xit "re-renders the 'new' template" do
          Person.stub(:new) { mock_person(:save => false) }
          post :create, :person => {}
          response.should render_template("new")
        end
      end
  
    end
  
    describe "PUT update" do
  
      describe "with valid params" do
        xit "updates the requested person" do
          Person.should_receive(:find).with("37") { mock_person }
          mock_person.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :person => {'these' => 'params'}
        end
  
        xit "assigns the requested person as @person" do
          Person.stub(:find) { mock_person(:update_attributes => true) }
          put :update, :id => "1"
          assigns(:person).should be(mock_person)
        end
  
        xit "redirects to the person" do
          Person.stub(:find) { mock_person(:update_attributes => true) }
          put :update, :id => "1"
          response.should redirect_to(person_url(mock_person))
        end
      end
  
      describe "with invalid params" do
        xit "assigns the person as @person" do
          Person.stub(:find) { mock_person(:update_attributes => false) }
          put :update, :id => "1"
          assigns(:person).should be(mock_person)
        end
  
        xit "re-renders the 'edit' template" do
          Person.stub(:find) { mock_person(:update_attributes => false) }
          put :update, :id => "1"
          response.should render_template("edit")
        end
      end
  
    end
  end
end
