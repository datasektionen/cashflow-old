require "spec_helper"

RSpec.describe PurchasesController do
  describe "routing" do
    context "locale = 'sv'" do
      it "recognizes and generates #index" do
        expect(get: "/inkop").
          to route_to("purchases#index", locale: "sv")
      end

      it "recognizes and generates #new" do
        expect(get: "/inkop/ny").
          to route_to("purchases#new", locale: "sv")
      end

      it "recognizes and generates #show" do
        expect(get: "/inkop/1").
          to route_to("purchases#show", id: "1", locale: "sv")
      end

      it "recognizes and generates #edit" do
        expect(get: "/inkop/1/redigera").
          to route_to("purchases#edit", id: "1", locale: "sv")
      end

      it "recognizes and generates #create" do
        expect(post: "/inkop").
          to route_to("purchases#create", locale: "sv")
      end

      it "recognizes and generates #update" do
        expect(put: "/inkop/1").
          to route_to("purchases#update", id: "1", locale: "sv")
      end

      it "recognizes and generates #destroy" do
        expect(delete: "/inkop/1").
          to route_to("purchases#destroy", id: "1", locale: "sv")
      end
    end

    context "locale = 'en'" do
      it "recognizes and generates #index" do
        expect(get: "/en/purchases").
          to route_to("purchases#index", locale: "en")
      end

      it "recognizes and generates #new" do
        expect(get: "/en/purchases/new").
          to route_to("purchases#new", locale: "en")
      end

      it "recognizes and generates #show" do
        expect(get: "/en/purchases/1").
          to route_to("purchases#show", id: "1", locale: "en")
      end

      it "recognizes and generates #edit" do
        expect(get: "/en/purchases/1/edit").
          to route_to("purchases#edit", id: "1", locale: "en")
      end

      it "recognizes and generates #create" do
        expect(post: "/en/purchases").
          to route_to("purchases#create", locale: "en")
      end

      it "recognizes and generates #update" do
        expect(put: "/en/purchases/1").
          to route_to("purchases#update", id: "1", locale: "en")
      end

      it "recognizes and generates #destroy" do
        expect(delete: "/en/purchases/1").
          to route_to("purchases#destroy", id: "1", locale: "en")
      end
    end
  end
end
