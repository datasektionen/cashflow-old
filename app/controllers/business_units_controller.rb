class BusinessUnitsController < ApplicationController
  load_and_authorize_resource# :find_by => :short_name
  before_filter :get_items, :only => [:show, :edit, :update, :destroy]

  # GET /business_units
  # GET /business_units.xml
  def index
    @business_units = BusinessUnit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @business_units }
    end
  end

  # GET /business_units/1
  # GET /business_units/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @business_unit }
    end
  end

  # GET /business_units/new
  # GET /business_units/new.xml
  def new
    @business_unit = BusinessUnit.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @business_unit }
    end
  end

  # GET /business_units/1/edit
  def edit
  end

  # POST /business_units
  # POST /business_units.xml
  def create
    @business_unit = BusinessUnit.new(params[:business_unit])

    respond_to do |format|
      if @business_unit.save
        format.html { redirect_to(@business_unit, :notice => I18n.t('notices.business_unit.success.created')) }
        format.xml  { render :xml => @business_unit, :status => :created, :location => @business_unit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @business_unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /business_units/1
  # PUT /business_units/1.xml
  def update
    respond_to do |format|
      if @business_unit.update_attributes(params[:business_unit])
        format.html { redirect_to(@business_unit, :notice => I18n.t('notices.business_unit.success.updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @business_unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /business_units/1
  # DELETE /business_units/1.xml
  def destroy
    unless @business_unit.destroy
      flash[:error] = I18n.t('activerecord.errors.models.business_unit.cannot_be_removed')
    end

    respond_to do |format|
      format.html { redirect_to(business_units_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def get_items
    @items = [{:key   => :show_business_unit, 
               :name  => @business_unit.name, 
               :url   => business_unit_path(@business_unit)},
              {:key   => :edit_business_unit,
               :name  => I18n.t('edit'),
               :url   => edit_business_unit_path(@business_unit)},
             ]
  end
end
