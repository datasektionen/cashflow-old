module PurchasesHelper
  def budget_posts_for_purchase(purchase)
    purchase.budget_post.nil? ? nil : purchase.business_unit.budget_posts
  end
end
