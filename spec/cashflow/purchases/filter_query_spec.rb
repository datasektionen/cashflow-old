require 'cashflow/purchases/filter_query'

module Cashflow
  module Purchases
    class Purchase
    end

    describe FilterQuery do
      let(:filter_class) { Cashflow::Purchases::FilterQuery }

      describe "#new" do
        context "with valid parameters" do
          it "can be instantiated" do
            expect {
              filter_class.new
            }.not_to raise_exception
          end

          it "accepts filter parameters" do
            expect {
              filter_class.new({})
            }.not_to raise_exception
          end

          it "assigns @filters to the filter parameters" do
            filter_params = {:foo => :bar}

            filter = filter_class.new(filter_params)

            filter.filters.should == filter_params
          end
        end
      end

      describe "#execute" do
        context "no filters" do
          it "returns the base class" do
            filter = filter_class.new({})

            filter.execute.should == Purchase
          end
        end

        context "with nil parameters" do
          it "returns the base class" do
            filter = filter_class.new(nil)

            filter.execute.should == Purchase
          end
        end

        context "non-filterable field filters" do
          it "doesn't query for non-filterable fields" do
            filters = { id: 0, foo: :bar }
            filter = filter_class.new(filters)

            filter.execute.should == Purchase
          end
        end

        context "filter workflow_states" do
          let(:filters) { {workflow_state: ["foo"] } }
          let(:filter) { filter_class.new(filters) }

          it "queries for the requested workflow_state" do
            Purchase.should_receive(:where).with(filters)
            
            filter.execute
          end
        end

        context "filter person_id" do
          it "queries for the requested person" do
            filters = {person_id: "1"}
            filter = filter_class.new(filters)
            Purchase.should_receive(:where).with(filters)
            
            filter.execute
          end

          it "does not include nil filters" do
            filters = {person_id: "", workflow_state: ["foo"]}
            filter = filter_class.new(filters)

            Purchase.should_receive(:where).with({workflow_state: ["foo"]})

            filter.execute
          end
        end

        context "filter business_unit_id" do
          it "queries for the requested business unit" do
            filters = {business_unit_id: "1"}
            filter = filter_class.new(filters)
            Purchase.should_receive(:where).with("budget_posts.business_unit_id" => "1")

            filter.execute
          end

          it "does not include nil filters" do
            filters = {business_unit_id: "", workflow_state: ["foo"]}
            filter = filter_class.new(filters)

            Purchase.should_receive(:where).with({workflow_state: ["foo"]})

            filter.execute
          end
        end
      end
    end
  end
end
