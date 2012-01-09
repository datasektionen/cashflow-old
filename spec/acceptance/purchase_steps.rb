# encoding: utf-8

steps_for :purchases do
  use_steps :budget_posts
  def fill_out_purchase_details
    fill_in("purchase_purchased_at", with: Date.today.to_s)
    select(@business_unit.name, from: "business_unit")
    select(@budget_post.name, from: "purchase_budget_post_id")
    fill_in("purchase_description", with: "foo")
  end

  def fill_out_last_purchase_item_details
    amount = all(".purchase_item .number.required input").last[:id]
    product_type = all(".purchase_item .select.required select").last[:id]
    fill_in(amount, with: "100")
    select(@product_type.name, from: product_type)
  end

  step "I have made a purchase that needs registering" do
    # setup some stuff that will be needed later
    @budget_post ||= Factory :budget_post
    @business_unit ||= @budget_post.business_unit
    @product_type ||= Factory :product_type
  end

  step "a purchase" do
    step 'I have made a purchase that needs registering'
    #step 'I fill out the new purchase form accordingly'
    PaperTrail.whodunnit = @person.id.to_s
    @purchase = Factory :purchase, person: @person
  end

  step "I fill out the new purchase form accordingly" do
    visit("/purchases/new")
    fill_out_purchase_details
    fill_out_last_purchase_item_details
    click_button("Spara Inköp")
  end


  step "my purchase should be registered" do
    page.should have_content(Purchase.last.slug)  
  end

  step "I fill out the new purchase form with \":count\" items" do |n|
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

  step "the purchase should have \":count\" purchase items" do |n|
    Purchase.last.items.count.should == n.to_i
  end
end

