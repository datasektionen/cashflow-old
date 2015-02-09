# encoding: utf-8

module PurchaseHelpers
  def select_from_chosen(item_text, options)
    field = find_field(options[:from], visible: false)
    option_js = "$(\"##{field[:id]} option:contains('#{item_text}')\").val()"
    option_value = page.evaluate_script(option_js)
    page.execute_script(<<-EOJS
     value = ["#{option_value}"]\;
     if ($("##{field[:id]}").val()) {
       $.merge(value, $("##{field[:id]}").val())
     }
    EOJS
    )
    option_value = page.evaluate_script("value")
    page.execute_script("$('##{field[:id]}').val(#{option_value})")
    page.execute_script("$('##{field[:id]}').trigger('chosen:updated')")
    page.execute_script("$('##{field[:id]}').change()")
  end

  def fill_out_purchase_details
    fill_in("purchase_purchased_on", with: Date.today.to_s)
    select_from_chosen(@budget_post.name, from: "purchase_budget_post_id")
    fill_in("purchase_description", with: "foo")
  end

  def fill_out_last_purchase_item_details
    amount = all(".purchase_item .number.required input").last[:id]
    product_type = all(".purchase_item fieldset .select.required span select",
                       visible: false).last[:id]
    fill_in(amount, with: "100")
    select_from_chosen(@product_type.name, from: product_type)
  end

  def setup_purchase_prerequisits
    @budget_post ||= create(:budget_post)
    @business_unit ||= @budget_post.business_unit
    @product_type ||= create(:product_type)
  end

  def create_purchase(number_of_items =  1)
    setup_purchase_prerequisits
    PaperTrail.whodunnit = @person.id.to_s

    @purchase = create(:purchase, person: @person)

    number_of_items.times do
      @purchase.items << create(:purchase_item, purchase: @purchase)
    end
    @purchase.reload
  end

  def filter_purchase_date(to_or_from, date)
    page.find_by_id("purchase_filter_toggle").click
    fill_in("filter_purchased_on_#{to_or_from}", with: date)
    fill_in("filter_search", with: "")
    page.find_by_id("filter_submit").click
  end
end

World(PurchaseHelpers)

Given(/^I have made a purchase that needs registering$/) do
  setup_purchase_prerequisits
end

Given(/^a purchase$/) do
  Purchase.paper_trail_on!
  create_purchase
end

Given(/^a purchase with "([^"]*)" items$/) do |_number_of_items|
  create_purchase(2)
end

When(/^I fill out the new purchase form accordingly$/) do
  visit("/inkop/ny")
  fill_out_purchase_details
  fill_out_last_purchase_item_details
  click_button("Spara Inköp")
end

When(/^I forget to choose a "budget post"$/) do
  @description = Time.now.to_s

  visit("/inkop/ny")

  fill_in("purchase_purchased_on", with: Date.today.to_s)
  fill_in("purchase_description", with: @description)

  fill_out_last_purchase_item_details
  click_button("Spara Inköp")
end

Then(/^my purchase should be registered$/) do
  page.should have_content("")
  page_header = "##{Purchase.last.slug.upcase}"
  page.should have_content(page_header)
end

When(/^I fill out the new purchase form with "(\d+)" items$/) do |n|
  n = n.to_i
  visit("/inkop/ny")
  fill_out_purchase_details
  fill_out_last_purchase_item_details
  (1...n).each do |_i|
    click_link("Lägg till inköpsdel")
    fill_out_last_purchase_item_details
  end
  click_button("Spara Inköp")
end

Then(/^(?:(?:the|my|that) )?purchase should have "(\d+)" purchase items$/) do |n|
  Purchase.last.items.count.should == n.to_i
end

Then(/^my purchase should not be registered$/) do
  if last_purchase = Purchase.last
    last_purchase.description.should_not == @description
  end
end

Then(/^I should get an error message on the "budget post" field$/) do
  page.should have_content "måste anges"
end

When(/^I edit the description of that purchase$/) do
  @description = Time.now.to_s

  visit("/inkop/#{@purchase.slug}/redigera")

  fill_in("purchase_description", with: @description)

  click_button("Uppdatera Inköp")
end

Then(/^the description should be updated$/) do
  page.should have_content @description
  @purchase = @purchase.reload
  @purchase.description.should == @description
end

Given(/^there exists at least one purchase of each status$/) do
  @purchases = []
  Purchase.workflow_spec.states.each do |_name, state|
    step "a purchase"
    @purchase.update_column(:workflow_state, state.to_s)
  end
end

When(/^I go to the purchases page$/) do
  visit purchases_path
end

Then(/^I should see all purchases$/) do
  Purchase.all.each do |purchase|
    page.should have_content purchase.description
  end
end

When(/^I filter the purchases by statuses "([^"]*)"$/) do |statuses|
  page.find_by_id("purchase_filter_toggle").click
  @statuses = statuses.split(",").map(&:strip)
  @statuses.each do |status|
    status = I18n.t("workflow_state.#{status}")
    select_from_chosen(status, from: "filter_workflow_state")
  end
  page.find_by_id("filter_submit").click
end

Then(/^I should see purchases with statuses "([^"]*)"$/) do |statuses|
  purchases = Purchase.where(workflow_state: statuses.split(/,/).map(&:strip))
  purchases.each do |purchase|
    page.should have_content purchase.id
    page.should have_content purchase.description
  end
end

Then(/^I should not see any other purchases$/) do
  relevant = @purchases.reject { |p| @statuses.include? p.workflow_state }
  relevant.each do |purchase|
    page.should have_no_content("##{purchase.id}")
    page.should have_no_content(purchase.description)
  end
end

When(/^I remove the first of those items$/) do
  visit(edit_purchase_path(@purchase))
  first(:link, "Ta bort inköpsdel").click
  click_button("Uppdatera Inköp")
end

Then(/^only the second item should remain$/) do
  page.should have_no_content @purchase.items.first.comment
  @purchase.reload

  @purchase.items.count.should == 1
end

Given(/^there exists a purchase with "lorem ipsum" in the description$/) do
  step "a purchase"
  @purchase.update_column(:description, "lorem ipsum")
end

When(/^I search for "lore"$/) do
  fill_in("filter_search", with: "lorem")
  click_button("search_submit")
end

Then(/^I should see that purchase among the results$/) do
  page.should have_content(@purchase.description)
end

Given(/^purchases purchased on a few different dates$/) do
  @purchased_on_range = {
    too_old: 3.days.ago.to_date.to_s,
    from: 2.days.ago.to_date.to_s,
    to: 1.days.ago.to_date.to_s,
    too_new: Date.today.to_s
  }
  @purchases = @purchased_on_range.values.map { |date|
    create(:purchase, purchased_on: date)
  }
end

When(/^I filter purchased_on (to|from) a date$/) do |date|
  filter_purchase_date(date, @purchased_on_range[date.to_sym])
end

Then(/^I should see a filtered list of purchases$/) do
  page.should have_content("Inköp")
end

Then(/^I should see purchases purchased from that date$/) do
  page.should have_content(@purchased_on_range[:from])
end

Then(/^I should see purchases purchased to that date$/) do
  page.should have_content(@purchased_on_range[:to])
end

Then(/^I should see no purchases older than that date$/) do
  page.should have_no_content(@purchased_on_range[:too_old])
end

Then(/^I should see no purchases newer than that date$/) do
  page.should have_no_content(@purchased_on_range[:too_new])
end

Then(/^the purchased_on filter value should be remembered$/) do
  page.find_by_id("purchase_filter_toggle").click
  filter_field = find_field("filter_purchased_on_from")
  filter_field.value.should eq(@purchased_on_range[:from])
end
