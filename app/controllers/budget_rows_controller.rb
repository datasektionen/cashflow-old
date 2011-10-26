class BudgetRowsController < ApplicationController
  load_and_authorize_resource

  before_filter :get_year
  before_filter :get_items, except: [:index]

  # GET /budget_rows
  # GET /budget_rows.xml
  def index
    @budget_rows = BudgetRow.year(@year)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @budget_rows }
    end
  end

  # GET /budget_rows/1
  # GET /budget_rows/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @budget_row }
    end
  end

  # GET /budget_rows/1/edit
  def edit
  end

  # PUT /budget_rows/1
  # PUT /budget_rows/1.xml
  def update
    respond_to do |format|
      if @budget_row.update_attributes(params[:budget_row])
        format.html { redirect_to(budget_row_path(budget_id: @year, id: @budget_row), :notice => 'Budget row was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @budget_row.errors, :status => :unprocessable_entity }
      end
    end
  end

protected

  def get_year
    @year = params[:budget_id]
  end  

  def get_items
    @items = [{key:  :show_budget,
               name: t('budget_for_year', year: @year),
               url:   budget_path(id: @year)
              },
              {:key   => :show_budget_row, 
               :name  => @budget_row.budget_post.name, 
               :url   => budget_row_path(budget_id: @budget_row.year, id: @budget_row.id)},
              { :key => :edit_budget_row,
                :name => I18n.t('edit'),
                :url => edit_budget_row_path(budget_id: @budget_row.year, id: @budget_row.id)},
             ]
    if is_mobile_device?
      @items.unshift({ :key => :budget_rows_list,
                  :name => I18n.t('back'),
                  :url => budget_rows_path(@year)})
    end
  end

end
