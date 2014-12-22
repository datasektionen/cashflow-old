module Mage
  class MappingsController < ApplicationController
    def index
      @mapper = Mage::Mapper.instance
      @business_units = BusinessUnit.all
      @budget_posts = BudgetPost.all
      @product_types = ProductType.all
    end

    def update
      Mage::Mapper.instance.save(params[:mappings])
      redirect_to action: :index
    end
  end
end
