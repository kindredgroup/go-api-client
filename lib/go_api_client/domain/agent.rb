module GoApiClient
  module Domain
    class Agent < GoApiClient::AttributeHelper

      attr_accessor :uuid, :hostname, :ip_address, :enabled, :sandbox, :status, :operating_system, :free_space, :resources, :environments

      def initialize(attributes)
        super(attributes)
      end
    end
  end
end