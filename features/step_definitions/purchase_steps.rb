Given /^I have made a purchase that needs registering$/ do
  # setup some stuff that will be needed later
  @budget_post = Factory :budget_post
  @business_unit = @budget_post.business_unit
  @product_type = Factory :product_type
end

When /^I fill out the new purchase form accordingly$/ do
  visit("/purchases/new")
  fill_in("purchase_purchased_at", with: Date.today.to_s)
  select(@business_unit.name, from: "business_unit")
  select(@budget_post.name, from: "purchase_budget_post_id")
  fill_in("purchase_description", with: "foo")
  fill_in("purchase_items_attributes_0_amount", with: "100")
  select(@product_type.name, from: "purchase_items_attributes_0_product_type_id")
  click_button("purchase_submit")
end


Then /^my purchase should be registered$/ do
  page.should have_content(Purchase.last.slug)  
end
