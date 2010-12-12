class PurchasesController < ApplicationController
  load_and_authorize_resource
  before_filter :get_items, :only => [:show, :edit, :update, :destroy]

  # GET /purchases
  # GET /purchases.xml
  def index
    @purchases = Purchase.accessible_by(current_ability)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @purchases }
    end
  end

  # GET /purchases/1
  # GET /purchases/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @purchase }
    end
  end

  # GET /purchases/new
  # GET /purchases/new.xml
  def new
    @purchase = Purchase.new
    @purchase.items.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @purchase }
    end
  end

  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases
  # POST /purchases.xml
  def create
    @purchase = current_user.purchases.new(params[:purchase])
    @purchase.updated_by = current_user
    @purchase.created_by = current_user

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to(@purchase, :notice => 'Purchase was successfully created.') }
        format.xml  { render :xml => @purchase, :status => :created, :location => @purchase }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @purchase.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /purchases/1
  # PUT /purchases/1.xml
  def update
    @purchase.updated_by = current_user

    respond_to do |format|
      if @purchase.update_attributes(params[:purchase])
        format.html { redirect_to(@purchase, :notice => 'Purchase was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @purchase.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.xml
  def destroy
    @purchase.destroy

    respond_to do |format|
      format.html { redirect_to(purchases_url) }
      format.xml  { head :ok }
    end
  end
  protected
  def get_items
    @items = [{:key   => :show_purchase_path,
               :name  => @purchase.name,
               :url   => purchase_path(@purchase)},
              {:key   => :edit_purchase_path,
               :name  => "Redigera",
               :url   => edit_purchase_path(@purchase)},
             ]
  end
end
