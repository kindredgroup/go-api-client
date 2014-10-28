module GoApiClient
  module Domain
    class Changeset < GoApiClient::AttributeHelper

      attr_accessor :parsed_user, :checkin_time, :revision, :message, :files, :uri

      def initialize(attributes={})
        super(attributes)
      end

    end
  end
end
