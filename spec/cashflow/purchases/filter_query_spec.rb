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
              filter_class.new(:foo)
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
          it "queries for all purchases" do
            Purchase.should_receive(:all)

            filter = filter_class.new({})

            filter.execute
          end
        end

        context "with nil parameters" do
          it "queries for all purchases" do
            Purchase.should_receive(:all)

            filter = filter_class.new(nil)

            filter.execute
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
      end
    end
  end
end
