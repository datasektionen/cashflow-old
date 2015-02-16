class BusinessUnitsController < ApplicationController
  load_and_authorize_resource # :find_by => :short_name
  before_filter :get_items, only: [:show, :edit, :update, :destroy]

  def index
    @business_units = BusinessUnit.all
  end

  def show
  end

  def new
    @business_unit = BusinessUnit.new
  end

  def edit
  end

  def create
    @business_unit = BusinessUnit.new(params[:business_unit])

    if @business_unit.save
      redirect_to(@business_unit,
                  notice: I18n.t("notices.business_unit.success.created"))
    else
      render :new
    end
  end

  def update
    if @business_unit.update_attributes(params[:business_unit])
      redirect_to(@business_unit,
                  notice: I18n.t("notices.business_unit.success.updated"))
    else
      render :edit
    end
  end

  def destroy
    unless @business_unit.destroy
      i18n_path = "activerecord.errors.models.business_unit.cannot_be_removed"
      flash[:error] = I18n.t(i18n_path)
    end

    redirect_to(business_units_url)
  end

  protected

  def get_items
    @items = [{ key: :show_business_unit,
                name: @business_unit.name,
                url: business_unit_path(@business_unit) },
              { key: :edit_business_unit,
                name: I18n.t("edit"),
                url: edit_business_unit_path(@business_unit) }
             ]
  end
end
