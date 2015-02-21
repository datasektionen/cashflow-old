require "rails_helper"

RSpec.feature "Manage purchases" do
  include PurchaseHelpers

  before(:all) { PaperTrail.enabled = true }

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
        business_unit = purchase.business_unit
        slug_match = "#{business_unit.short_name.upcase}#{Time.now.year}"
        expect(page).to have_content("##{slug_match}-")
        expect(page).to have_selector("#items tbody tr", count: 1)
      end

      scenario "forgetting to enter budget post" do
        description = Time.now.to_s + rand(4711).to_s

        visit("/inkop/ny")

        fill_in("purchase_purchased_on", with: Date.today.to_s)
        fill_in("purchase_description", with: description)

        click_button("Spara Inköp")

        expect(page).to have_content("")

        purchase = Purchase.last
        expect(purchase.try(:description)).not_to eq(description)
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

      description = "updated description: #{Time.now.to_s}"
      fill_in("purchase_description", with:description)
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
    before(:each) do
      # Background:
      #   Given a person with the "treasurer" role
      #   And I am logged in as the person
      #   And there exists at least one purchase of each status
      #   And I go to the purchases page
      skip "TODO: implement"
    end

    scenario "No filter specified" do
      # Then I should see all purchases
      skip "TODO: implement"
    end

    scenario "Filter by single status" do
      # When I filter the purchases by statuses "new"
      # Then I should see purchases with statuses "new"
      # And I should not see any other purchases
      skip "TODO: implement"
    end

    scenario "Filter by multiple statuses" do
      # When I filter the purchases by statuses "new, edited"
      # Then I should see purchases with statuses "new, edited"
      # And I should not see any other purchases
      skip "TODO: implement"
    end

    scenario "Search purchases by description text" do
      # Given there exists a purchase with "lorem ipsum" in the description
      # When I search for "lore"
      # Then I should see that purchase among the results
      skip "TODO: implement"
    end

    scenario "Filter purchased_on from a date" do
      # Given purchases purchased on a few different dates
      # When I filter purchased_on from a date
      # Then I should see a filtered list of purchases
      # And I should see purchases purchased from that date
      # And I should see no purchases older than that date
      skip "TODO: implement"
    end

    scenario "Filter purchased_on to a date" do
      # Given purchases purchased on a few different dates
      # When I filter purchased_on to a date
      # Then I should see a filtered list of purchases
      # And I should see purchases purchased to that date
      # And I should see no purchases newer than that date
      skip "TODO: implement"
    end

    scenario "Remembering filter parameters" do
      # Given purchases purchased on a few different dates
      # When I filter purchased_on from a date
      # Then the purchased_on filter value should be remembered
      skip "TODO: implement"
    end
  end
end
