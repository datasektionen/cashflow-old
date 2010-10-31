class ProductTypesController < ApplicationController
  def index
    @product_types = ProductType.all
  end
end
