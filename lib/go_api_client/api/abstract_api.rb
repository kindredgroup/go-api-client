module GoApiClient
  module Api
    class AbstractApi < GoApiClient::AttributeHelper
      protected
      attr_accessor :http_fetcher, :base_uri

      def initialize(attributes={})
        super(attributes)
      end
    end
  end
end