module PurchasesHelper
  def budget_posts_for_purchase(purchase)
    purchase.budget_post.nil? ? nil : purchase.business_unit.budget_posts
  end

  def link_to_originator(version)
    if version.originator
      link_to(version.originator.name, person_path(version.originator))
    else
      ""
    end
  end
end
