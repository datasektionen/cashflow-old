class PeopleController < ApplicationController
  before_filter :get_person, :only => [:show, :edit, :update, :destroy]
  before_filter :get_items, :only => [:show, :edit, :update, :destroy]
  
  
  # GET /people
  # GET /people.xml
  def index
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @people }
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])

    respond_to do |format|
      if @person.save
        format.html { redirect_to(@person, :notice => 'Person was successfully created.') }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to(@person, :notice => 'Person was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    unless @person.destroy
      flash[:error] = "Användaren gick inte att ta bort"
    end

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def get_person
    @person = Person.find(params[:id])
  end
  def get_items
    @items = [{:key   => :show_person, 
               :name  => @person.name, 
               :url   => person_path(@person)},
              { :key => :edit_person,
                :name => "Redigera",
                :url => edit_person_path(@person)},
             ]
    if is_mobile_device?
      @items.unshift({ :key => :people_list,
                  :name => "Tillbaka",
                  :url => people_path})
    end
  end
  
end
