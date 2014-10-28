require 'nokogiri'

module GoApiClient
  module Api
    class Cctray < GoApiClient::Api::AbstractApi

      def initialize(attributes = {})
        super(attributes)
      end

      # Answers if a build is in progress. For the list of supported connection options
      # @see .build_finished?
      # @pipeline_name [String]  The name of the pipeline that should be fetched.
      def build_in_progress?(pipeline_name)
        uri = "#{@base_uri}/cctray.xml"
        doc = Nokogiri::XML(@http_fetcher.get!(uri))
        doc.css("Project[activity='Building'][name^='#{pipeline_name} ::']").count > 0
      end

      # Answers if a build is in completed. For the list of supported connection options
      # @see .build_in_progress?
      # @pipeline_name [String]  The name of the pipeline that should be fetched.
      def build_finished?(pipeline_name)
        !build_in_progress?(pipeline_name)
      end
    end
  end
end