require "rails_helper"

RSpec.feature "Manage purchases", js: true, slow: true do
  include ActiveSupport::NumberHelper
  include PurchaseHelpers

  before(:all) do
    PaperTrail.enabled = true
  end

  let(:person) { create(:person) }

  before(:each) { login_as(person) }

  describe "Registering purchases", js: true, versioning: true, slow: true do
    context "with a single item" do
      scenario "saves the purchase with the item" do
        purchase = build(:purchase_with_items)

        visit(new_purchase_path)

        fill_out_purchase_form(purchase)

        click_button("Spara Inköp")

        expect(page).to have_content("Inköp skapat")
        expect(page).to have_content(purchase.description)
        expect(page).to have_selector("#items tbody tr", count: 1)
      end

      scenario "forgetting to enter budget post" do
        description = Time.now.to_s + rand(4711).to_s

        visit("/inkop/ny")

        fill_in("purchase_purchased_on", with: Date.today.to_s)
        fill_in("purchase_description", with: description)

        click_button("Spara Inköp")

        expect(page).to have_css("#purchase_budget_post_id.error",
                                 visible: false)
      end
    end

    context "with multiple items" do
      scenario "persists all items" do
        purchase = build(:purchase_with_items, item_count: 2)

        visit(new_purchase_path)

        fill_out_purchase_form(purchase)

        click_button("Spara Inköp")

        expect(page).to have_content("Inköp skapat")
        business_unit = purchase.business_unit
        slug_match = "#{business_unit.short_name.upcase}#{Time.now.year}"
        expect(page).to have_content("##{slug_match}-")
        expect(page).to have_selector("#items tbody tr", count: 2)
      end
    end
  end

  describe "Editing purchases", js: true, versioning: true, slow: true do
    scenario "Confirming a purchase"
    scenario "Rejecting a bad purchase"
    scenario "Cancelling an edited purchase"
    scenario "Marking a confirmed purchase as bookkept"
    scenario "Marking a confirmed purchase as paid"
    scenario "Finalizing a confirmed purchase"
    scenario "Finalizing a paid purchase"

    scenario "Editing a purchase" do
      purchase = create(:purchase_with_items, item_count: 2, person: person)
      visit(edit_purchase_path(purchase))

      description = "upd: #{Time.now}"
      fill_in("purchase_description", with: description)
      click_button("Uppdatera Inköp")

      slug_match = "#{purchase.business_unit.short_name.upcase}#{Time.now.year}"
      expect(page).to have_content("Inköp uppdaterat")
      expect(page).to have_content("##{slug_match}-")
      expect(page).to have_content(description)
    end

    scenario "Removing items from a purchase" do
      purchase = create(:purchase_with_items, item_count: 2, person: person)
      visit(edit_purchase_path(purchase))

      first(:link, "Ta bort inköpsdel").click
      click_button("Uppdatera Inköp")

      slug_match = "#{purchase.business_unit.short_name.upcase}#{Time.now.year}"
      expect(page).to have_content("Inköp uppdaterat")
      expect(page).to have_content("##{slug_match}-")
      expect(page).to have_selector("#items tbody tr", count: 1)
    end
  end

  describe "Filtering purchases", js: true, versioning: true, slow: true do
    let(:person) { create(:person, role: "treasurer") }

    before(:each) do
      login_as person
      visit purchases_path
    end

    context "filter by status" do
      before(:all) do
        Purchase.destroy_all
        Purchase.workflow_spec.states.each do |_name, state|
          create(:purchase, description: "test #{state}").tap do |purchase|
            purchase.update(workflow_state: state)
          end
        end
      end

      after(:all) do
        Purchase.destroy_all
      end

      scenario "No filter specified" do
        Purchase.all.each do |purchase|
          expect(page).to have_content(purchase.description)
        end
      end

      scenario "Filter by single status" do
        filter_statuses("new")

        purchases = Purchase.where(workflow_state: "new")
        purchases.each do |purchase|
          expect(page).to have_content(purchase.id)
          expect(page).to have_content(purchase.description)
        end

        filtered = Purchase.where.not(id: purchases)
        filtered.each do |purchase|
          expect(page).to have_no_content("##{purchase.id}")
          expect(page).to have_no_content(purchase.description)
        end
      end

      scenario "Filter by multiple statuses" do
        filter_statuses("new", "edited")

        purchases = Purchase.where(workflow_state: ["new", "edited"])
        purchases.each do |purchase|
          expect(page).to have_content(purchase.id)
          expect(page).to have_content(purchase.description)
        end

        filtered = Purchase.where.not(id: purchases)
        filtered.each do |purchase|
          expect(page).to have_no_content("##{purchase.id}")
          expect(page).to have_no_content(purchase.description)
        end
      end
    end

    context "search" do
      scenario "Search purchases by description text" do
        purchase = create(:purchase, description: "purchase lorem ipsum")
        other_purchase = create(:purchase, description: "no search hit")
        visit purchases_path

        fill_in("filter_search", with: "lorem")
        page.find_by_id("search_submit").click

        expect(page).to have_content(purchase.description)
        expect(page).to have_no_content(other_purchase.description)
      end
    end

    context "filter by date" do
      before(:all) do
        3.downto(0) do |n|
          create(:purchase, purchased_on: n.days.ago.to_date.to_s)
        end
      end

      scenario "Filter purchased_on from a date" do
        date = 2.days.ago.to_date.to_s
        filter_purchase_date(:from, date)

        expect(page).to have_content(date)
        expect(page).to have_no_content(3.days.ago.to_date.to_s)
      end

      scenario "Filter purchased_on to a date" do
        date = 1.days.ago.to_date.to_s
        filter_purchase_date(:to, date)

        expect(page).to have_content(date)
        expect(page).to have_no_content(0.days.ago.to_date.to_s)
      end

      scenario "Remembering filter parameters" do
        date = 2.days.ago.to_date.to_s
        filter_purchase_date(:from, date)

        page.find_by_id("purchase_filter_toggle").click
        filter_field = find_field("filter_purchased_on_from")

        expect(filter_field.value).to eq(date)
      end
    end
  end

  describe "Pay confirmed purchases" do
    let(:person) { create(:admin) }

    before(:each) { login_as(person) }

    scenario "view multiple confirmed purchases" do
      confirmed_purchases = [
        create(:purchase_with_items, workflow_state: "confirmed"),
        create_list(:purchase_with_items, 2,
                    person: person, workflow_state: "confirmed")
      ].flatten
      new_purchase = create(:purchase, person: person, workflow_state: :new)

      visit confirmed_purchases_path

      confirmed_purchases.each do |purchase|
        expect(page).to have_content(purchase.person.name)
        amount = purchase.person.total_purchased_amount
        expect(page).to have_content(number_to_currency amount)
      end

      expect(page).to have_no_content(new_purchase.description)
    end

    scenario "mark multiple confirmed purchases as paid" do
      confirmed_purchases = create_list(:confirmed_purchase, 5)
      visit confirmed_purchases_path
      confirmed_purchases.each do |purchase|
        within "#person-#{purchase.person.id}" do
          check "Betala"
        end
      end
      click_button "Betala!"

      expect(page).to have_content("Betalda (#{confirmed_purchases.map(&:id)})")
      confirmed_purchases.each do |purchase|
        expect(purchase.reload).to be_paid
      end
    end
  end
end
