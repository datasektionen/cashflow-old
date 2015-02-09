require "spec_helper"

describe BusinessUnitsController do
  describe "routing" do
    context "locale = 'sv'" do
      it "recognizes and generates #index" do
        expect(get: "/affarsenheter").
          to route_to("business_units#index", locale: "sv")
      end

      it "recognizes and generates #new" do
        expect(get: "/affarsenheter/ny").
          to route_to("business_units#new", locale: "sv")
      end

      it "recognizes and generates #show" do
        expect(get: "/affarsenheter/1").
          to route_to("business_units#show", id: "1", locale: "sv")
      end

      it "recognizes and generates #edit" do
        expect(get: "/affarsenheter/1/redigera").
          to route_to("business_units#edit", id: "1", locale: "sv")
      end

      it "recognizes and generates #create" do
        expect(post: "/affarsenheter").
          to route_to("business_units#create", locale: "sv")
      end

      it "recognizes and generates #update" do
        expect(put: "/affarsenheter/1").
          to route_to("business_units#update", id: "1", locale: "sv")
      end

      it "recognizes and generates #destroy" do
        expect(delete: "/affarsenheter/1").
          to route_to("business_units#destroy", id: "1", locale: "sv")
      end
    end
     
    context "locale = 'en'" do
      it "recognizes and generates #index" do
        expect(get: "/en/business_units").
          to route_to("business_units#index", locale: "en")
      end

      it "recognizes and generates #new" do
        expect(get: "/en/business_units/new").
          to route_to("business_units#new", locale: "en")
      end

      it "recognizes and generates #show" do
        expect(get: "/en/business_units/1").
          to route_to("business_units#show", id: "1", locale: "en")
      end

      it "recognizes and generates #edit" do
        expect(get: "/en/business_units/1/edit").
          to route_to("business_units#edit", id: "1", locale: "en")
      end

      it "recognizes and generates #create" do
        expect(post: "/en/business_units").
          to route_to("business_units#create", locale: "en")
      end

      it "recognizes and generates #update" do
        expect(put: "/en/business_units/1").
          to route_to("business_units#update", id: "1", locale: "en")
      end

      it "recognizes and generates #destroy" do
        expect(delete: "/en/business_units/1").
          to route_to( "business_units#destroy", id: "1", locale: "en")
      end
    end
  end
end
