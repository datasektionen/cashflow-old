require "spec_helper"

RSpec.describe PeopleController do
  describe "routing" do
    context "locale = 'sv'" do
      it "recognizes and generates #index" do
        expect(get: "/personer").
          to route_to("people#index", locale: "sv")
      end

      it "recognizes and generates #new" do
        expect(get: "/personer/ny").
          to route_to("people#new", locale: "sv")
      end

      it "recognizes and generates #show" do
        expect(get: "/personer/1").
          to route_to("people#show", id: "1", locale: "sv")
      end

      it "recognizes and generates #edit" do
        expect(get: "/personer/1/redigera").
          to route_to("people#edit", id: "1", locale: "sv")
      end

      it "recognizes and generates #create" do
        expect(post: "/personer").
          to route_to("people#create", locale: "sv")
      end

      it "recognizes and generates #update" do
        expect(put: "/personer/1").
          to route_to("people#update", id: "1", locale: "sv")
      end

      it "doesn't recognize and generate #destroy" do
        expect(delete: "/personer/1").not_to be_routable
      end
    end

    context "locale = 'en'" do
      it "recognizes and generates #index" do
        expect(get: "/en/people").
          to route_to("people#index", locale: "en")
      end

      it "recognizes and generates #new" do
        expect(get: "/en/people/new").
          to route_to("people#new", locale: "en")
      end

      it "recognizes and generates #show" do
        expect(get: "/en/people/1").
          to route_to("people#show", id: "1", locale: "en")
      end

      it "recognizes and generates #edit" do
        expect(get: "/en/people/1/edit").
          to route_to("people#edit", id: "1", locale: "en")
      end

      it "recognizes and generates #create" do
        expect(post: "/en/people").
          to route_to("people#create", locale: "en")
      end

      it "recognizes and generates #update" do
        expect(put: "/en/people/1").
          to route_to("people#update", id: "1", locale: "en")
      end

      it "doesn't recognize and generate #destroy" do
        expect(delete: "/en/people/1").not_to be_routable
      end
    end
  end
end
