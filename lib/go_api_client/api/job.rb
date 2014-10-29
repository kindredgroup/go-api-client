require 'nokogiri'

module GoApiClient
  module Api
    class Job < GoApiClient::Api::AbstractApi

      def initialize(attributes = {})
        super(attributes)
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

      def scheduled_jobs
        uri = "#{@base_uri}/api/jobs/scheduled.xml"
        Nokogiri::XML(@http_fetcher.post!(uri)).root.xpath('./job').collect do |element|
          GoApiClient::Parsers::ScheduledJob.parse(element)
        end
      end
    end
  end
end