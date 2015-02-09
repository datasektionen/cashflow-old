require "spec_helper"

describe BudgetController do
  describe "routing" do

    context "locale = 'sv'" do
      it "routes to #index" do
        expect(get("/budget")).to route_to("budget#index", locale: "sv")
      end

      it "routes to #new" do
        expect(get("/budgetposter/ny")).to route_to("budget_posts#new",
                                                    locale: "sv")
      end

      it "routes to #show" do
        expect(get("/budget/#{Time.now.year}")).to route_to(
          "budget#show", id: Time.now.year.to_s, locale: "sv")
      end

      it "routes to #edit" do
        expect(get("/budget/#{Time.now.year}/redigera")).to route_to(
          "budget#edit", id: "#{Time.now.year}", locale: "sv")
      end

      it "routes to #create" do
        expect(post("/budgetposter")).to route_to("budget_posts#create",
                                                  locale: "sv")
      end

      it "routes to #update" do
        expect(put("/budget/#{Time.now.year}")).to route_to(
          "budget#update", id: "#{Time.now.year}", locale: "sv")
      end

      it "routes to #destroy" do
        expect(delete("/budget/1")).not_to be_routable
      end
    end

    context "locale = 'en'" do
      it "routes to #index" do
        expect(get("/en/budget")).to route_to("budget#index", locale: "en")
      end

      it "routes to #new" do
        expect(get("/en/budget_posts/new")).to route_to("budget_posts#new",
                                                        locale: "en")
      end

      it "routes to #show" do
        expect(get("/en/budget/#{Time.now.year}")).to route_to(
          "budget#show", id: Time.now.year.to_s, locale: "en")
      end

      it "routes to #edit" do
        expect(get("/en/budget/#{Time.now.year}/edit")).to route_to(
          "budget#edit", id: "#{Time.now.year}", locale: "en")
      end

      it "routes to #create" do
        expect(post("/en/budget_posts")).to route_to("budget_posts#create",
                                                     locale: "en")
      end

      it "routes to #update" do
        expect(put("/en/budget/#{Time.now.year}")).to route_to(
          "budget#update", id: "#{Time.now.year}", locale: "en")
      end

      it "routes to #destroy" do
        expect(delete("/en/budget/1")).not_to be_routable
      end
    end
  end
end
