# Renders an ItemContainer as a <ul> element and its containing items as <li>
# elements.  Prepared to use inside the topbar of Twitter Bootstrap
# http://twitter.github.com/bootstrap/#navigation
#
# Register the renderer and use following code in your view:
#   render_navigation(level: 1..2,
#                     renderer: :bootstrap_topbar_list,
#                     expand_all: true)
class BootstrapMenuList < SimpleNavigation::Renderer::Base
  def render(item_container)
    return "" if skip_if_empty? && item_container.empty?

    content_tag(:ul,
                list_content(item_container),
                id: item_container.dom_id,
                class: flat_string([item_container.dom_class, ul_class]))
  end

  def render_sub_navigation_for(item)
    item.sub_navigation.render(options.merge(is_subnavigation: true))
  end

  protected

  def tag_for(item)
    if include_sub_navigation?(item)
      link_name = item.name + content_tag(:b, "", class: "caret")
      return link_to(link_name.html_safe, "#", link_options_for(item))
    end

    if item.url.nil?
      item.name
    else
      link_to(item.name, item.url, link_options_for(item))
    end
  end

  # Extracts the options relevant for the generated link
  def link_options_for(item)
    special_options = { method: item.method }.reject { |_k, v| v.nil? }

    if include_sub_navigation?(item) && !options[:is_subnavigation]
      special_options[:"data-toggle"] = "dropdown"
    end

    link_options = item.html_options[:link] || {}
    opts = special_options.merge(link_options)
    opts[:class] = flat_string([link_options[:class],
                                item.selected_class,
                                dropdown_link_class(item)])
    opts.delete(:class) if opts[:class].nil? || opts[:class] == ""
    opts
  end

  def dropdown_link_class(item)
    if include_sub_navigation?(item) && !options[:is_subnavigation]
      "dropdown-toggle"
    end
  end

  private

  # remove the link from the list item options
  def li_options(item)
    item.html_options.reject { |k, _v| k == :link }.tap do |options|
      if include_sub_navigation?(item)
        options[:class] = flat_string([options[:class], "dropdown"])
      end
    end
  end

  # create the link and add possible sub navigation
  def li_content(item)
    tag_for(item).tap do |content|
      if include_sub_navigation?(item)
        content << render_sub_navigation_for(item)
      end
    end
  end

  # create the list item with oiur above content and options
  def list_content(item_container)
    list_content = item_container.items.inject([]) do |list, item|
      list << content_tag(:li, li_content(item), li_options(item))
    end
    list_content.join
  end

  def ul_class
    if options[:is_subnavigation]
      "dropdown-menu"
    else
      flat_string(["nav navbar-nav", options[:bootstrap_menu_type]])
    end
  end

  def flat_string(array)
    array.flatten.compact.join(" ")
  end
end
