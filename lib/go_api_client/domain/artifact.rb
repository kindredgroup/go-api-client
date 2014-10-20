module GoApiClient
  module Domain
    class Artifact < GoApiClient::Domain::Helper

      attr_accessor :base_uri, :src, :dest, :artifact_type

      def initialize(attributes)
        super(attributes)
      end

      def as_zip_file_url
        "#{File.join(base_uri, src)}.zip"
      end
    end
  end
end