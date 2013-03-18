module GoApiClient
  class Artifact
    attr_accessor :base_uri, :src, :dest, :artifact_type
    include GoApiClient::Helpers::SimpleAttributesSupport

    def initialize(attributes)
      super(attributes)
    end

    def as_zip_file_url
      "#{File.join(base_uri, src)}.zip"
    end

    class << self
      def from(artifact_base_uri, artifact_element)
        attributes = {
          :base_uri      => artifact_base_uri,
          :src           => artifact_element.attributes['src'].value,
          :dest          => artifact_element.attributes['dest'].value,
          :artifact_type => artifact_element.attributes['type'].value,
        }
        
        self.new(attributes)
      end
    end
  end
end