require 'nokogiri'

module GoApiClient
  module Api
    class Stage < GoApiClient::Api::AbstractApi

      def initialize(attributes = {})
        attributes = ({:pipeline_cache => {}, :stage_cache => {}}).merge(attributes)
        super(attributes)
      end

      def stage(options = {})
        options = ({:stage_uri => nil, :stage_id => nil, :pipeline_name => nil, :pipeline_tag => nil, :stage_name => nil, :stage_counter => nil, :eager_parser => []}).merge(options)
        if options[:stage_uri]
          uri = options[:stage_uri]
        elsif options[:stage_id]
          uri = "#{@base_uri}/api/stages/#{options[:stage_id]}.xml"
        else
          raise 'Insufficient arguments' unless options[:pipeline_name] && options[:pipeline_tag] && options[:stage_name] && options[:stage_counter]
          uri = "#{@base_uri}/pipelines/#{options[:pipeline_name]}/#{options[:pipeline_tag]}/#{options[:stage_name]}/#{options[:stage_counter]}.xml"
        end
        stage = GoApiClient::Parsers::Stage.parse(Nokogiri::XML(@http_fetcher.get!(uri)).root)
        @stage_cache[GoApiClient::Domain::InternalCache.new(stage.self_uri, options)] ||= stage
        if options[:eager_parser]
          if options[:eager_parser].include?(:job)
            job_api = GoApiClient::Api::Job.new({:base_uri => @base_uri, :http_fetcher => @http_fetcher})
            stage.parsed_jobs = stage.jobs.collect do |job_uri|
              job_api.job(options.merge({:job_uri => job_uri}))
            end
          end
          if options[:eager_parser].include?(:pipeline)
            pipeline_api = GoApiClient::Api::Pipeline.new({:base_uri => @base_uri, :http_fetcher => @http_fetcher, :pipeline_cache => @pipeline_cache, :stage_cache => @stage_cache})
            pipeline = @pipeline_cache[GoApiClient::Domain::InternalCache.new(stage.pipeline_uri, options)] || pipeline_api.pipeline(options.merge({:pipeline_uri => stage.pipeline_uri}))
            @pipeline_cache[GoApiClient::Domain::InternalCache.new(stage.pipeline_uri, options)] ||= pipeline
            stage.parsed_pipeline = pipeline
          end
        end
        stage
      end

      private
      attr_accessor :pipeline_cache, :stage_cache
    end
  end
end