require 'nokogiri'

module GoApiClient
  module Api
    class Feed < GoApiClient::Api::AbstractApi

      def initialize(attributes = {})
        super(attributes)
      end

      def feed(options={})
        options = ({:pipeline_name => nil, :feed_uri => nil, :eager_parser => []}).merge(options)
        if options[:feed_uri]
          uri = options[:feed_uri]
        else
          raise 'Insufficient arguments' unless options[:pipeline_name]
          uri = "#{@base_uri}/api/pipelines/#{options[:pipeline_name]}/stages.xml"
        end
        feed = GoApiClient::Parsers::Feed.parse(Nokogiri::XML(@http_fetcher.get!(uri)).root)

        if options[:eager_parser]
          if options[:eager_parser].include?(:stage)
            stage_api = GoApiClient::Api::Stage.new({:base_uri => @base_uri, :http_fetcher => @http_fetcher})
            feed.parsed_entries.each do |entry|
              entry.parsed_stage = stage_api.stage(options.merge({:stage_uri => entry.stage_uri}))
            end
          end
          if options[:eager_parser].include?(:pipeline)
            pipeline_api = GoApiClient::Api::Pipeline.new({:base_uri => @base_uri, :http_fetcher => @http_fetcher})
            feed.parsed_entries.each do |entry|
              entry.parsed_pipeline = pipeline_api.pipeline(options.merge({:pipeline_uri => entry.pipeline_uri}))
            end
          end
        end
        feed
      end
    end
  end
end