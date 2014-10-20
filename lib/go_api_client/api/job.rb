require 'nokogiri'

module GoApiClient
  module Api
    class Job
      attr_reader :http_fetcher, :base_uri

      def initialize(base_uri, http_fetcher)
        @http_fetcher = http_fetcher
        @base_uri = base_uri
      end

      def job(options = {})
        if options[:job_uri]
          uri = options[:job_uri]
        else
          raise 'Insufficient arguments' unless options[:job_id]
          uri = "#{@base_uri}/api/jobs/#{options[:job_id]}.xml"
        end
        GoApiClient::Parsers::Job.parse(Nokogiri::XML(@http_fetcher.get!(uri)).root)
      end
    end
  end
end
