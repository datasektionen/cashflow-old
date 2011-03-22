class DebtsController < ApplicationController
  load_and_authorize_resource

  # GET /debts
  # GET /debts.xml
  def index
    @debts = Debt.accessible_by(current_ability)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @debts }
    end
  end

  # GET /debts/1
  # GET /debts/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @debt }
    end
  end

  # GET /debts/new
  # GET /debts/new.xml
  def new
    @debt = Debt.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @debt }
    end
  end

  # GET /debts/1/edit
  def edit
  end

  # POST /debts
  # POST /debts.xml
  def create
    @debt = Debt.new(params[:debt])

    respond_to do |format|
      if @debt.save
        Notifier.debt_created(@debt, current_person).deliver
        format.html { redirect_to(@debt, :notice => 'Debt was successfully created.') }
        format.xml  { render :xml => @debt, :status => :created, :location => @debt }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @debt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /debts/1
  # PUT /debts/1.xml
  def update

    respond_to do |format|
      if @debt.update_attributes(params[:debt])
        format.html { redirect_to(@debt, :notice => 'Debt was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @debt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /debts/1
  # DELETE /debts/1.xml
  def destroy
    @debt = Debt.find(params[:id])
    #@debt.destroy

    respond_to do |format|
      format.html { redirect_to(debts_url) }
      format.xml  { head :ok }
    end
  end

  def cancel
    @debt.cancel!
    Notifier.debt_cancelled(@debt, current_person).deliver
    respond_to do |format|
      format.html { redirect_to(debt_path(@debt)) }
    end
  end

  def pay
    @debt.pay!
    Notifier.debt_paid(@debt, current_person).deliver
    respond_to do |format|
      format.html { redirect_to(debt_path(@debt)) }
    end
  end
  
  def keep
    @debt.keep!
    respond_to do |format|
      format.html { redirect_to(debt_path(@debt)) }
    end
  end
end
