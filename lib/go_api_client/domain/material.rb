module GoApiClient
  module Domain
    class Material < GoApiClient::Domain::Helper

      attr_accessor :uri, :type, :pipeline_name, :stage_name, :branch, :url
      attr_accessor :parsed_changesets

      def initialize(attributes)
        super(attributes)
      end
    end
  end
end

