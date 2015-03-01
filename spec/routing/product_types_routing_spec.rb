require "rails_helper"

RSpec.describe ProductTypesController do
  describe "routing" do
    context "locale = 'sv'" do
      it "recognizes and generates #index" do
        expect(get: "/produkttyper").
          to route_to("product_types#index", locale: "sv")
      end

      it "recognizes and generates #new" do
        expect(get: "/produkttyper/ny").
          to route_to("product_types#new", locale: "sv")
      end

      it "recognizes and generates #show" do
        expect(get: "/produkttyper/1").
          to route_to("product_types#show", id: "1", locale: "sv")
      end

      it "recognizes and generates #edit" do
        expect(get: "/produkttyper/1/redigera").
          to route_to("product_types#edit", id: "1", locale: "sv")
      end

      it "recognizes and generates #create" do
        expect(post: "/produkttyper").
          to route_to("product_types#create", locale: "sv")
      end

      it "recognizes and generates #update" do
        expect(put: "/produkttyper/1").
          to route_to("product_types#update", id: "1", locale: "sv")
      end

      it "recognizes and generates #destroy" do
        expect(delete: "/produkttyper/1").
          to route_to("product_types#destroy", id: "1", locale: "sv")
      end
    end

    context "locale = 'en'" do
      it "recognizes and generates #index" do
        expect(get: "/en/product_types").
          to route_to("product_types#index", locale: "en")
      end

      it "recognizes and generates #new" do
        expect(get: "/en/product_types/new").
          to route_to("product_types#new", locale: "en")
      end

      it "recognizes and generates #show" do
        expect(get: "/en/product_types/1").
          to route_to("product_types#show", id: "1", locale: "en")
      end

      it "recognizes and generates #edit" do
        expect(get: "/en/product_types/1/edit").
          to route_to("product_types#edit", id: "1", locale: "en")
      end

      it "recognizes and generates #create" do
        expect(post: "/en/product_types").
          to route_to("product_types#create", locale: "en")
      end

      it "recognizes and generates #update" do
        expect(put: "/en/product_types/1").
          to route_to("product_types#update", id: "1", locale: "en")
      end

      it "recognizes and generates #destroy" do
        expect(delete: "/en/product_types/1").
          to route_to("product_types#destroy", id: "1", locale: "en")
      end
    end
  end
end
