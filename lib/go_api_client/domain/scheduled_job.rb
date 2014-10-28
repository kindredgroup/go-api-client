module GoApiClient
  module Domain
    class ScheduledJob < GoApiClient::AttributeHelper

      attr_accessor :name, :id, :self_uri, :build_locator, :resources, :environment_variables, :environment

      def initialize(attributes={})
        super(attributes)
      end
    end
  end
end
