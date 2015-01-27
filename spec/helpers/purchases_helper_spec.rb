require "spec_helper"

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
describe PurchasesHelper do
  describe "budget_posts_for_purchase" do
    it "returns the available budget posts to the purchase's business unit" do
      budget_posts = [create(:budget_post), create(:budget_post)]
      business_unit = stub_model(BusinessUnit, budget_posts: budget_posts)
      purchase = stub_model(Purchase,
                            business_unit: business_unit,
                            budget_post: budget_posts.first)

      helper.budget_posts_for_purchase(purchase).should == budget_posts
    end

    it "returns nil if the purchase doesn't have a budget post" do
      purchase = stub_model(Purchase)
      helper.budget_posts_for_purchase(purchase).should be nil
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
                               originator: person,
                               workflow_state: "New")
      helper.link_to_originator(version).should ==
        link_to(version.originator.name, person_path(version.originator))
    end

    it "returns an empty string when originator is missing" do
      version = OpenStruct.new
      helper.link_to_originator(version).should == ''
    end
  end

  describe "filter_search_tag" do
    it "returns a text field tag with the filter name" do
      helper.filter_search_tag("foo", "foo bar baz").should ==
        '<input id="filter_foo" name="filter[foo]"' +
        ' placeholder="foo bar baz" type="text" />'
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
      helper.filter_select_tag("xs", collection, :foo, :bar, options).should ==
        '<select id="filter_xs" multiple="multiple" name="filter[xs][]" ' +
        'placeholder="foos?"><option value=""></option>' +
        "<option value=\"1\">one</option>\n<option value=\"2\">two</option>" +
        "</select>"
    end
  end

  describe "filter_date_range_tags" do
    it "returns a label and a date picker" do
      helper.filter_date_range_tags("foo").should ==
        '<div id="purchase_foo_filter">' +
        '<label for="filter_foo_from">Från</label>' +
        '<input class="datepicker" id="filter_foo_from"' +
              ' name="filter[foo_from]" placeholder="Välj ett startdatum"' +
              ' type="text" />' +
        '<label for="filter_foo_to">till och med</label>' +
        '<input class="datepicker" id="filter_foo_to"' +
              ' name="filter[foo_to]" placeholder="Välj ett slutdatum"' +
              ' type="text" />' +
        "</div>"
    end
  end
end
