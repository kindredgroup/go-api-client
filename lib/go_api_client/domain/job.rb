module GoApiClient
  module Domain
    class Job < GoApiClient::AttributeHelper

      attr_accessor :artifacts_uri, :console_log_url, :self_uri, :id, :name, :parsed_artifacts,
                    :duration, :state, :result, :scheduled, :assigned, :preparing, :building, :completing, :completed

      def initialize(attributes={})
        super(attributes)
      end

      def console_log_url
        @console_log_url ||= "#{artifacts_uri}/cruise-output/console.log"
      end
    end
  end
end
