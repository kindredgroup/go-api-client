module GoApiClient
  module Parsers
    class Artifact
      class << self
        def parse(uri, root)
          GoApiClient::Domain::Artifact.new(
              {
                  :base_uri => uri,
                  :src => root.attributes['src'].value,
                  :dest => root.attributes['dest'].value,
                  :artifact_type => root.attributes['type'].value,
              })
        end
      end
    end
  end
end