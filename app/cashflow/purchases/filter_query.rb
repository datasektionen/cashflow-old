module Cashflow
  module Purchases
    class FilterQuery
      attr_reader :filters

      def initialize(filter = {})
        filter ||= {}
        filter.delete_if {|key, value| value.nil? || value.empty? }

        @filters = filter
      end

      def execute
        if @filters.empty?
          Purchase
        else
          Purchase.where(@filters)
        end
      end
    end
  end
end
