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

  def filter_purchase_date(to_or_from, date)
    page.find_by_id("purchase_filter_toggle").click
    fill_in("filter_purchased_on_#{to_or_from}", with: date)
    page.find_by_id("filter_submit").trigger("click")
  end

  def fill_out_purchase_form(purchase = nil)
    purchase ||= build(:purchase)

    select_from_chosen(purchase.budget_post.name,
                       from: "purchase_budget_post_id")

    purchase.items.each do |item|
      amount = all(".purchase_item .number.required input").last[:id]
      product_type = all(".purchase_item fieldset .select.required span select",
                               visible: false).last[:id]
      fill_in(amount, with: item.amount)
      select_from_chosen(item.product_type.name, from: product_type)

      click_link("Lägg till inköpsdel") unless item == purchase.items.last
    end

    fill_in("purchase_description", with: purchase.description)
    fill_in("purchase_purchased_on", with: purchase.purchased_on)

    purchase
  end
end
