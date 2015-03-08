require "rails_helper"

RSpec.feature "Add users", type: :feature do
  describe "First login", slow: true do
    let(:person) { build(:person, ugid: "u1dhz6b0") }

    before(:each) do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:cas, uid: person.ugid)
    end

    scenario "imports credentials and redirects to new purchase path" do
      allow(Person).to receive(:create_from_ldap).with(ugid: "u1dhz6b0") do
        person.save!
        person
      end

      login_as(person)

      imported_person = Person.find_by(ugid: person.ugid)
      expect(imported_person.first_name).to eq("Martin")
      expect(imported_person.last_name).to eq("Frost")

      expect(current_path).to eq(new_purchase_path)
    end
  end
end
