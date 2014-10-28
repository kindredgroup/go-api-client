module GoApiClient
  module Domain
    class Feed < GoApiClient::AttributeHelper

      attr_accessor :updated, :title, :id, :self_uri, :next_uri
      attr_accessor :parsed_entries, :parsed_authors

      def initialize(attributes={})
        super(attributes)
      end
    end
  end
end
