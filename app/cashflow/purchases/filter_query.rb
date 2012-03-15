module Cashflow
  module Purchases
    class FilterQuery
      FILTERED_PARAMS = [:workflow_state, :person_id, business_unit_id: :budget_post]
      FILTETED_PARAM_SYMS = FILTERED_PARAMS.map{|p| p.is_a?(Hash) ? p.keys : p }.flatten

      attr_reader :filters

      def initialize(filter = {})
        filter ||= {}
        filter.delete_if {|key, value| !FILTETED_PARAM_SYMS.include?(key.to_sym) || value.nil? || value.empty? }

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
