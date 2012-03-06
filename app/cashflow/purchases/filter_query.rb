module Cashflow
  module Purchases
    class FilterQuery
      attr_reader :filters

      def initialize(filter = {})
        @filters = filter || {}
      end

      def execute
        if @filters.empty?
          Purchase.all
        else
          Purchase.where(@filters)
        end
      end
    end
  end
end
