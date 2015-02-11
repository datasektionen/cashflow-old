require "spec_helper"

describe BudgetRowsController do
  describe "routing" do
    context "locale = 'sv'" do
      it "routes to #index" do
        expect(get("/budget/#{Time.now.year}/budgetrader")).
          to route_to("budget_rows#index",
                      budget_id: Time.now.year.to_s,
                      locale: "sv")
      end

      it "routes to #show" do
        expect(get("/budget/#{Time.now.year}/budgetrader/1")).
          to route_to("budget_rows#show",
                      id: "1",
                      budget_id: Time.now.year.to_s,
                      locale: "sv")
      end

      it "routes to #edit" do
        expect(get("/budget/#{Time.now.year}/budgetrader/1/redigera")).
          to route_to("budget_rows#edit",
                      id: "1",
                      budget_id: Time.now.year.to_s,
                      locale: "sv")
      end

      it "routes to #update" do
        expect(put("/budget/#{Time.now.year}/budgetrader/1")).
          to route_to("budget_rows#update",
                      id: "1",
                      budget_id: Time.now.year.to_s,
                      locale: "sv")
      end
    end

    context "locale = 'en'" do
      it "routes to #index" do
        expect(get("/en/budget/#{Time.now.year}/budget_rows")).
          to route_to("budget_rows#index",
                      budget_id: Time.now.year.to_s,
                      locale: "en")
      end

      it "routes to #show" do
        expect(get("/en/budget/#{Time.now.year}/budget_rows/1")).
          to route_to("budget_rows#show",
                      id: "1",
                      budget_id: Time.now.year.to_s,
                      locale: "en")
      end

      it "routes to #edit" do
        expect(get("/en/budget/#{Time.now.year}/budget_rows/1/edit")).
          to route_to("budget_rows#edit",
                      id: "1",
                      budget_id: Time.now.year.to_s,
                      locale: "en")
      end

      it "routes to #update" do
        expect(put("/en/budget/#{Time.now.year}/budget_rows/1")).
          to route_to("budget_rows#update",
                      id: "1",
                      budget_id: Time.now.year.to_s,
                      locale: "en")
      end
    end
  end
end
