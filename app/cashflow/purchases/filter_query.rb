module Cashflow
  module Purchases
    class FilterQuery
      FILTERED_PARAMS = [:workflow_state, :person_id, ]
      FILTERED_ASSOCIATION_PARAMS = { business_unit_id: :budget_posts }
      FILTETED_PARAM_SYMS = FILTERED_PARAMS | FILTERED_ASSOCIATION_PARAMS.keys

      attr_reader :filters

      def initialize(filter = {})
        filter ||= {}
        filter.delete_if {|key, value| filter_param_should_be_removed?(key, value) }

        prefix_params_on_associations_with_association_table_name(filter)

        @filters = filter
      end

      def execute
        if @filters.empty?
          Purchase
        else
          Purchase.where(@filters)
        end
      end

    private
      def filter_param_should_be_removed?(key, value)
        !FILTETED_PARAM_SYMS.include?(key.to_sym) || value.nil? || value.empty?
      end

      def prefix_params_on_associations_with_association_table_name(filter)
        FILTERED_ASSOCIATION_PARAMS.each do |param,assoc|
          value = filter.delete(param.to_sym) || filter.delete(param.to_s)
          filter["%s.%s" % [assoc, param]] = value unless value.nil?
        end
      end
    end
  end
end
