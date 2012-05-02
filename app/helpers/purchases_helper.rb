# encoding: utf-8

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

  def filter_date_range_tags name
    content_tag :div, :id => "purchase_#{name}_filter" do
      content = ""
      content += label_tag "filter[#{name.to_s}_from]", 'Från'
      content += text_field_tag "filter[#{name.to_s}_from]", params['filter'].try(:[], "#{name.to_s}_from"), :class => 'datepicker', :placeholder => 'Välj ett startdatum'
      content += label_tag "filter[#{name.to_s}_to]", 'till och med'
      content += text_field_tag "filter[#{name.to_s}_to]", params['filter'].try(:[], "#{name.to_s}_to"), :class => 'datepicker', :placeholder => 'Välj ett slutdatum'
      content.html_safe
    end
  end
end
