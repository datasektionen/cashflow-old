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

  def active_filter?(state, filters)
    filters ||= {workflow_state: []}
    filters[:workflow_state].include?(state.to_s)
  end

  def hidden_filter_tag(state, filters)
    options = {id: "filter_workflow_state_#{state}"}
    options[:disabled] = "disabled" unless active_filter?(state, filters)
    hidden_field_tag "filter[workflow_state][]", state.to_s, options
  end

  def filter_button(state, filters)
    content_tag(:div, I18n.t(state.to_s, scope: [:workflow_state]), {name: state.to_s, value: state.to_s, class: active_filter?(state, filters) ? "btn active" : "btn"})
  end
end
