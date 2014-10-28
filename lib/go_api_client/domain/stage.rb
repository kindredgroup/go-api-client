module GoApiClient
  module Domain
    class Stage < GoApiClient::AttributeHelper

      # Self attributes
      attr_accessor :name, :counter
      # Tags
      attr_accessor :id, :self_uri, :result, :state, :approved_by, :jobs, :updated
      # Pipeline tag
      attr_accessor :pipeline_name, :pipeline_counter, :pipeline_label, :pipeline_uri
      # Parsed object
      attr_accessor :parsed_pipeline, :parsed_jobs

      def initialize(attributes={})
        super(attributes)
      end

      def failed?
        'Failed' == @result
      end

      def passed?
        !failed?
      end
    end
  end
end

