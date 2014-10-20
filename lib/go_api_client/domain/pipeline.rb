module GoApiClient
  module Domain
    class Pipeline < GoApiClient::Domain::Helper

      # TODO: Add materials

      # Self attributes
      attr_accessor :name, :counter, :label
      # Tags
      attr_accessor :id, :self_uri, :inserted_after_uri, :schedule_time, :stages, :approved_by
      # Parsed object
      attr_accessor :parsed_stages, :parsed_materials

      def initialize(attributes={})
        super(attributes)
      end

      def stages
        @stages ||= []
      end

      def authors
        @authors ||= stages.first.authors
      end
    end
  end
end
