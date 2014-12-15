class ProductTypesController < ApplicationController
  load_and_authorize_resource
  before_filter :get_items, only: [:show, :edit, :update, :destroy]

  def index
    @product_types = ProductType.all
  end

  def show
  end

  def new
    @product_type = ProductType.new
  end

  def edit
  end

  def create
    @product_type = ProductType.new(params[:product_type])

    if @product_type.save
      redirect_to(@product_type, notice: I18n.t('notices.product_type.success.created'))
    else
      render action: 'new'
    end
  end

  def update
    if @product_type.update_attributes(params[:product_type])
      redirect_to(@product_type, notice: I18n.t('notices.product_type.success.updated'))
    else
      render action: 'edit'
    end
  end

  def destroy
    unless @product_type.destroy
      flash[:error] = I18n.t('activerecord.errors.models.product_type.cannot_be_removed')
    end

    redirect_to(product_types_url)
  end

  protected

  def get_items
    @items = [{ key: :show_product_type,
                name: @product_type.name,
                url: product_type_path(@product_type) },
              { key: :edit_product_type,
                name: I18n.t('edit'),
                url: edit_product_type_path(@product_type) }
             ]
  end
end
