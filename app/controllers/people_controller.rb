class PeopleController < ApplicationController
  load_and_authorize_resource :person, :except => :search
  before_filter :get_items, :only => [:show, :edit, :update, :destroy]
  
  
  # GET /people
  # GET /people.xml
  def index
    @people = Person.accessible_by(current_ability)
    authorize! :access, @people
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
    search_options = params[:person].slice(*%w[login ugid email])
    @person = Person.where(search_options).first unless search_options.blank?
    @person ||= Person.from_ldap(search_options)
    

    respond_to do |format|
      if @person.save
        format.html { redirect_to(@person, :notice => I18n.t('notices.person.success.created')) }
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
    if params[:person].try(:[], :role) && current_person.is?(:admin)
      @person.role = params[:person][:role]
      @person.save
    end
    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to(@person, :notice => I18n.t('notices.person.success.created')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  def search
    search_options = params.slice(*%w[login ugid email])
    person = Person.where(search_options).first
    person ||= Person.from_ldap(search_options)
    respond_to do |format|
      format.json do
        if person.persisted?
          render :json => {:person => {:name => person.name}, :error => I18n.t('activerecord.errors.models.person.exists'), :url => person_url(person)}
        else
          render :json => person
        end
      end
    end
  end

  protected
  def get_items
    @items = [{:key   => :show_person, 
               :name  => @person.name, 
               :url   => person_path(@person)},
              { :key => :edit_person,
                :name => I18n.t('edit'),
                :url => edit_person_path(@person)},
             ]
    if is_mobile_device?
      @items.unshift({ :key => :people_list,
                  :name => I18n.t('back'),
                  :url => people_path})
    end
  end
end

