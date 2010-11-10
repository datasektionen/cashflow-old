class ProductTypesController < ApplicationController
  before_filter :get_type, :only => [:show, :edit, :update, :destroy]
  before_filter :get_items, :only => [:show, :edit, :update, :destroy]
  
  # GET /product_types
  # GET /product_types.xml
  def index
    @product_types = ProductType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_types }
    end
  end

  # GET /product_types/1
  # GET /product_types/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_type }
    end
  end

  # GET /product_types/new
  # GET /product_types/new.xml
  def new
    @product_type = ProductType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_type }
    end
  end

  # GET /product_types/1/edit
  def edit
  end

  # POST /product_types
  # POST /product_types.xml
  def create
    @product_type = ProductType.new(params[:product_type])

    respond_to do |format|
      if @product_type.save
        format.html { redirect_to(@product_type, :notice => 'Product type was successfully created.') }
        format.xml  { render :xml => @product_type, :status => :created, :location => @product_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /product_types/1
  # PUT /product_types/1.xml
  def update
    respond_to do |format|
      if @product_type.update_attributes(params[:product_type])
        format.html { redirect_to(@product_type, :notice => 'Product type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_types/1
  # DELETE /product_types/1.xml
  def destroy
    unless @product_type.destroy
      flash[:error] = "Produkttypen kunde inte tas bort"
    end

    respond_to do |format|
      format.html { redirect_to(product_types_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def get_type
    @product_type = ProductType.find(params[:id])
  end
  def get_items
    @items = [{:key   => :show_product_type, 
               :name  => @product_type.name, 
               :url   => product_type_path(@product_type)},
              { :key => :edit_product_type,
                :name => "Redigera",
                :url => edit_product_type_path(@product_type)},
             ]
  end
end
