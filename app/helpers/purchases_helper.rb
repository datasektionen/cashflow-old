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

  def filter_search_tag(name, placeholder)
    options = { placeholder: placeholder }
    text_field_tag "filter[#{name}]", params[:filter].try(:[], name), options
  end

  def filter_select_tag(name, collection, value_method, text_method, placeholder, options)
    options = { :"data-placeholder" => placeholder }.merge(options)
    filter = params[:filter].try(:[], name)
    collection_options = options_from_collection_for_select(collection,
                                                            value_method,
                                                            text_method,
                                                            filter)
    select_tag "filter[#{name}]", collection_options, options
  end

  def filter_date_range_tags(name)
    content_tag :div, id: "purchase_#{name}_filter" do
      content = ""
      content += content_tag :div, class: "form-group" do
        lt = label_tag "filter[#{name}_from]", "Från"
        tft = text_field_tag("filter[#{name}_from]",
                             params["filter"].try(:[], "#{name}_from"),
                             class: "form-control datepicker",
                             placeholder: "Välj ett startdatum")
        lt + tft
      end
      content += content_tag :div, class: "form-group" do
        name_attr = "filter[#{name}_to]"
        lt = label_tag name_attr, "till och med"
        tft = text_field_tag name_attr,
                             params["filter"].try(:[], "#{name}_to"),
                             class: "form-control datepicker",
                             placeholder: "Välj ett slutdatum"
        lt + tft
      end
      content.html_safe
    end
  end
end
