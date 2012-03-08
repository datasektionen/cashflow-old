# encoding: utf-8

def select_from_chosen(item_text, options)
  field = find_field(options[:from])
  option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
  page.execute_script("$('##{field[:id]}').val('#{option_value}')")
end

def fill_out_purchase_details
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
  PaperTrail.whodunnit = @person.id.to_s
  @purchase = Factory :purchase, person: @person
  @purchase.items << Factory(:purchase_item, purchase: @purchase)
  @purchase.reload
end

When /^I fill out the new purchase form accordingly$/ do
  visit("/purchases/new")
  fill_out_purchase_details
  fill_out_last_purchase_item_details
  click_button("Spara Inköp")
end

When /^I forget to choose a "budget post"$/ do
  @description = Time.now.to_s

  visit("/purchases/new")

  fill_in("purchase_purchased_at", with: Date.today.to_s)
  fill_in("purchase_description", with: @description)

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

Then /^my purchase should not be registered$/ do
  if last_purchase = Purchase.last
    last_purchase.description.should_not == @description
  end
end

Then /^I should get an error message on the "budget post" field$/ do
  page.should have_content "måste anges"
end

When /^I edit the description of that purchase$/ do
  @description = Time.now.to_s

  visit("/purchases/#{@purchase.slug}/edit")

  fill_in("purchase_description", with: @description)

  click_button("Uppdatera Inköp")
end

Then /^the description should be updated$/ do
  @purchase = @purchase.reload
  @purchase.description.should == @description
end

Given /^there exists at least one purchase of each status$/ do
  Purchase.workflow_spec.states.each do |name, state|
    Given 'a purchase'
    @purchase.update_attribute(:workflow_state, state)
  end
end

When /^I go to the purchases page$/ do
  visit purchases_path
end

Then /^I should see all purchases$/ do
  Purchase.all.each do |purchase|
    page.should have_content purchase.id
  end
end

When /^I filter the purchases by statuses "([^"]*)"$/ do |statuses|
  pending
  statuses.split(/,/).map(&:strip).each do |status|
    # TODO: click element
  end
  click_button("Filtrera!")
end

Then /^I should see purchases with statuses "([^"]*)"$/ do |statuses|
  Purchase.where(:workflow_status => statuses.split(/,/).map(&:strip)).each do |purchase|
    page.should have_content purchase.id
  end
end

Then /^I should not see any other purchases$/ do
  pending
end
