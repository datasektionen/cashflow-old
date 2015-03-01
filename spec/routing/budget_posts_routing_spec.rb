require "rails_helper"

RSpec.describe BudgetPostsController do
  describe "routing" do
    context "locale = 'sv'" do

      it "routes to #index" do
        expect(get("/budgetposter")).to route_to("budget_posts#index",
                                                 locale: "sv")
      end

      it "routes to #new" do
        expect(get("/budgetposter/ny")).to route_to("budget_posts#new",
                                                    locale: "sv")
      end

      it "routes to #show" do
        expect(get("/budgetposter/1")).to route_to("budget_posts#show",
                                                   id: "1", locale: "sv")
      end

      it "routes to #edit" do
        expect(get("/budgetposter/1/redigera")).
          to route_to("budget_posts#edit", id: "1", locale: "sv")
      end

      it "routes to #create" do
        expect(post("/budgetposter")).to route_to("budget_posts#create",
                                                  locale: "sv")
      end

      it "routes to #update" do
        expect(put("/budgetposter/1")).to route_to("budget_posts#update",
                                                   id: "1", locale: "sv")
      end

      it "routes to #destroy" do
        expect(delete("/budgetposter/1")).to route_to("budget_posts#destroy",
                                                      id: "1", locale: "sv")
      end
    end

    context "locale = 'en'" do

      it "routes to #index" do
        expect(get("/en/budget_posts")).to route_to("budget_posts#index",
                                                    locale: "en")
      end

      it "routes to #new" do
        expect(get("/en/budget_posts/new")).to route_to("budget_posts#new",
                                                        locale: "en")
      end

      it "routes to #show" do
        expect(get("/en/budget_posts/1")).to route_to("budget_posts#show",
                                                      id: "1", locale: "en")
      end

      it "routes to #edit" do
        expect(get("/en/budget_posts/1/edit")).
          to route_to("budget_posts#edit", id: "1", locale: "en")
      end

      it "routes to #create" do
        expect(post("/en/budget_posts")).to route_to("budget_posts#create",
                                                     locale: "en")
      end

      it "routes to #update" do
        expect(put("/en/budget_posts/1")).to route_to("budget_posts#update",
                                                      id: "1", locale: "en")
      end

      it "routes to #destroy" do
        expect(delete("/en/budget_posts/1")).to route_to("budget_posts#destroy",
                                                         id: "1", locale: "en")
      end
    end
  end
end
