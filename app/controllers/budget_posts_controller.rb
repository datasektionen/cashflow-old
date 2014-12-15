class BudgetPostsController < ApplicationController
  load_and_authorize_resource

  def index
    @budget_posts = BudgetPost.all
    @year = params[:year]
    @year = Time.now.year if @year.nil?
    BudgetRow.create_rows_if_not_exists(@year) # TODO: Refactor this to put it elsewhere. It doesn't belong here.

    @edit = params[:edit]
  end

  def show
  end

  def new
    @budget_post = BudgetPost.new
    @budget_post.mage_arrangement_number = 0 # THIS IS A HACK
  end

  def edit
  end

  def create
    @budget_post = BudgetPost.new(params[:budget_post])

    if @budget_post.save
      redirect_to(@budget_post, notice: 'Budget post was successfully created.')
    else
      render action: 'new'
    end
  end

  def update
    if @budget_post.update_attributes(params[:budget_post])
      redirect_to(budget_post_path(@budget_post), notice: I18n.t('notices.budget_post.success.updated'))
    else
      render action: 'edit'
    end
  end

  def destroy
    @budget_post = BudgetPost.find(params[:id])
    begin
      @budget_post.destroy
      notice = I18n.t('notices.budget_post.success.delete')
    rescue ActiveRecord::DeleteRestrictionError => e
      notice = I18n.t('notices.budget_post.error.delete_restricted')
    end

    redirect_to(budget_posts_url, notice: notice)
  end
end
