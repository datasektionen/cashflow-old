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

  def filter_select_tag(name, collection, value_method, text_method, options)
    filter = options_from_collection_for_select(collection,
                                                value_method,
                                                text_method,
                                                params[:filter].try(:[], name))
    select_tag "filter[#{name}]", filter, options
  end

  def filter_date_range_tags(name)
    content_tag :div, id: "purchase_#{name}_filter" do
      concat date_picker_tag("#{name}_from", "Från", "Välj ett startdatum")
      concat date_picker_tag("#{name}_to", "till och med", "Välj ett slutdatum")
    end
  end

  private

  def date_picker_tag(name, label, placeholder)
    capture do
      concat label_tag "filter[#{name}]", label
      concat text_field_tag("filter[#{name}]",
                            params[:filter].try(:[], name),
                            class: "datepicker",
                            placeholder: placeholder)
    end
  end
end
