# encoding: utf-8
def select_from_chosen(item_text, options)
  field = find_field(options[:from])
  option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
  page.execute_script("$('##{field[:id]}').val('#{option_value}')")
end

def fill_out_purchase_details
  sleep 2
  fill_in("purchase_purchased_at", with: Date.today.to_s)
  select_from_chosen(@budget_post.name, from: "purchase_budget_post_id")
  fill_in("purchase_description", with: "foo")
end

def fill_out_last_purchase_item_details
  amount = all(".purchase_item .number.required input").last[:id]
  product_type = all(".purchase_item .select.required select").last[:id]
  fill_in(amount, with: "100")
  select_from_chosen(@product_type.name, from: product_type)
end

Given /^I have made a purchase that needs registering$/ do
  # setup some stuff that will be needed later
  @budget_post ||= Factory :budget_post
  @business_unit ||= @budget_post.business_unit
  @product_type ||= Factory :product_type
end

Given /^a purchase$/ do
  Given 'I have made a purchase that needs registering'
  #Given 'I fill out the new purchase form accordingly'
  PaperTrail.whodunnit = @person.id.to_s
  @purchase = Factory :purchase, person: @person
end

When /^I fill out the new purchase form accordingly$/ do
  visit("/purchases/new")
  fill_out_purchase_details
  fill_out_last_purchase_item_details
  click_button("Spara Inköp")
end


Then /^my purchase should be registered$/ do
  page.should have_content(Purchase.last.slug)  
end

When /^I fill out the new purchase form with "(\d+)" items$/ do |n|
  n = n.to_i
  visit("/purchases/new")
  fill_out_purchase_details
  fill_out_last_purchase_item_details
  (1...n).each do |i|
    click_link("Lägg till inköpsdel")
    fill_out_last_purchase_item_details
  end
  click_button("Spara Inköp")
end

Then /^(?:(?:the|my|that) )?purchase should have "(\d+)" purchase items$/ do |n|
  Purchase.last.items.count.should == n.to_i
end
