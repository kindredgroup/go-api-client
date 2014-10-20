module GoApiClient
  module Domain
    class Entry < GoApiClient::Domain::Helper

      attr_accessor :updated, :title, :id, :stage_uri, :pipeline_uri
      attr_accessor :parsed_categories, :parsed_authors, :parsed_pipeline, :parsed_stage

      def initialize(attributes={})
        super(attributes)
      end
    end
  end
end
