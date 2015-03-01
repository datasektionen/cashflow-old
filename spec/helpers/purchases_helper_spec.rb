require "rails_helper"

# Specs in this file have access to a helper object that includes
# the PurchasesHelper. For example:
#
# describe PurchasesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
RSpec.describe PurchasesHelper do
  describe "budget_posts_for_purchase" do
    it "returns the available budget posts to the purchase's business unit" do
      budget_posts = [create(:budget_post), create(:budget_post)]
      business_unit = stub_model(BusinessUnit, budget_posts: budget_posts)
      purchase = stub_model(Purchase,
                            business_unit: business_unit,
                            budget_post: budget_posts.first)

      expect(helper.budget_posts_for_purchase(purchase)).to eq(budget_posts)
    end

    it "returns nil if the purchase doesn't have a budget post" do
      purchase = stub_model(Purchase)
      expect(helper.budget_posts_for_purchase(purchase)).to be nil
    end
  end

  describe "link_to_originator" do
    it "returns a link to a given purchase version's originator" do
      person = stub_model(Person,
                          id: 37,
                          login: "foobar",
                          first_name: "foo",
                          last_name: "bar")
      version = OpenStruct.new(purchase_date: Time.now,
                               last_modified_by: person,
                               workflow_state: "New")
      expect(helper.link_to_originator(version)).to eq(
        link_to(person.name, person_path(person))
      )
    end

    it "returns an empty string when originator is missing" do
      version = OpenStruct.new
      expect(helper.link_to_originator(version)).to eq("")
    end
  end

  describe "filter_search_tag" do
    it "returns a text field tag with the filter name" do
      expect(helper.filter_search_tag("foo", "foo bar baz")).to eq(
        '<input type="text" name="filter[foo]" id="filter_foo"' +
        ' placeholder="foo bar baz" />'
      )
    end
  end

  describe "filter_select_tag" do
    it "renders a select tag for filtering the specified collection" do
      collection = [
        OpenStruct.new(foo: 1, bar: "one"),
        OpenStruct.new(foo: 2, bar: "two")
      ]
      options = {
        placeholder: "foos?",
        include_blank: true,
        multiple: true
      }
      result = helper.filter_select_tag("xs", collection, :foo, :bar, options)
      expect(result).to eq(
        '<select name="filter[xs][]" id="filter_xs" placeholder="foos?" ' +
        'multiple="multiple"><option value=""></option>' +
        "<option value=\"1\">one</option>\n<option value=\"2\">two</option>" +
        "</select>"
      )
    end
  end

  describe "filter_date_range_tags" do
    it "returns a label and a date picker" do
      expect(helper.filter_date_range_tags("foo")).to eq(
        '<div id="purchase_foo_filter">' +
        '<label for="filter_foo_from">Från</label>' +
        '<input type="text" name="filter[foo_from]" id="filter_foo_from"' +
              ' class="datepicker" placeholder="Välj ett startdatum" />' +
        '<label for="filter_foo_to">till och med</label>' +
        '<input type="text" name="filter[foo_to]" id="filter_foo_to"' +
              ' class="datepicker" placeholder="Välj ett slutdatum" />' +
        "</div>"
      )
    end
  end
end
