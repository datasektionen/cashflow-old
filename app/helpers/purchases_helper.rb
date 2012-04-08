module PurchasesHelper
  def budget_posts_for_purchase(purchase)
    purchase.budget_post.blank? ? nil : purchase.business_unit.budget_posts
  end

  def link_to_originator(version)
    if version.originator
      link_to(version.originator.name, person_path(version.originator))
    else
      ""
    end
  end

  def filter_select_tag name, collection, value_method, text_method, placeholder, options
    options = {:'data-placeholder' => placeholder}.merge(options)
    select_tag "filter[#{name}]", options_from_collection_for_select(collection, value_method, text_method, params[:filter].try(:[], name)), options
  end
end
