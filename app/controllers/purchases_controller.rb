class PurchasesController < ApplicationController
  load_and_authorize_resource :except => [:confirmed, :pay_multiple]
  before_filter :get_items, :only => [:show, :edit, :update, :destroy]

  # GET /purchases
  # GET /purchases.xml
  def index
    @purchases = Purchase.joins(:person, :items, :budget_post => :business_unit).includes(:person, :items, :budget_post => :business_unit)
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
    @purchase = @current_user.purchases.new(params[:purchase])

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to(@purchase, :notice => I18n.t('notice.purchase.success.created')) }
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
    @purchase.workflow_state = "edited"

    respond_to do |format|
      if @purchase.update_attributes(params[:purchase])
        format.html { redirect_to(@purchase, :notice => I18n.t('notice.purchase.success.updated')) }
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
    #@purchase.destroy

    respond_to do |format|
      format.html { redirect_to(purchases_url) }
      format.xml  { head :ok }
    end
  end

  def confirmed
    authorize! :manage, Purchase
    @purchases = Purchase.where(:workflow_state => :confirmed)
    @purchases = @purchases.group_by{|p| p.person }.map{|k, v| {k => v.sum(&:total)} }
    @purchases = @purchases.inject({}){|s, h| s.merge(h)}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @purchases }
    end
  end

  def pay_multiple
    authorize! :manage, Purchase
    people_ids = params[:pay].keep_if{|k,v| v.to_i == 1 }.keys
    @purchases = Purchase.where(:workflow_state => :confirmed).where(:person_id => people_ids)
    @purchases.each{|p| p.pay! }
    respond_to do |format|
      format.html { redirect_to(confirmed_purchases_path, :notice => "Betalda (#{@purchases.map(&:id)})!") }
    end
  end

  def confirm
    @purchase.confirm!
    respond_to do |format|
      format.html { redirect_to(purchase_path(@purchase))}
    end
  end
  def pay
    @purchase.pay!
    respond_to do |format|
      format.html { redirect_to(purchase_path(@purchase))}
    end
  end

  def keep
    @purchase.keep!
    respond_to do |format|
      format.html { redirect_to(purchase_path(@purchase))}
    end
  end

  def cancel
    @purchase.cancel!
    respond_to do |format|
      format.html { redirect_to(purchase_path(@purchase))}
    end
  end

protected

  def get_items
    @items = [{:key   => :show_purchase_path,
               :name  => @purchase.slug,
               :url   => purchase_path(@purchase)}
    ]
    if @purchase.editable?
      @items << { 
        :key   => :edit_purchase_path,
        :name  => I18n.t('edit'),
        :url   => edit_purchase_path(@purchase)
      }
    end
  end
end
