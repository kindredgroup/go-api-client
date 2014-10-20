require 'nokogiri'

module GoApiClient
  module Api
    class Pipeline
      attr_reader :http_fetcher, :base_uri

      def initialize(base_uri, http_fetcher, options = {})
        options = ({:pipeline_cache => {}, :stage_cache => {}}).merge(options)
        @http_fetcher = http_fetcher
        @base_uri = base_uri
        @pipeline_cache = options[:pipeline_cache]
        @stage_cache = options[:stage_cache]
      end

      # Schedule a particular pipeline with the latest available materials.
      def schedule(options = {})
        # options {:materials => nil, :variables => nil, :secure_variables => nil}
        options = ({:schedule_uri => nil, :pipeline_name => nil}).merge(options)
        if options[:schedule_uri]
          uri = options[:schedule_uri]
        else
          raise 'Insufficient arguments' unless options[:pipeline_name]
          uri = "#{@base_uri}/api/pipelines/#{options[:pipeline_name]}/schedule"
        end
        @http_fetcher.post!(uri)
      end

      # This API allows you to release a lock on a pipeline so that you can start up a new instance without
      # having to wait for the earlier instance to finish.
      def release_lock(options = {})
        options = ({:release_lock_uri => nil, :pipeline_name => nil}).merge(options)
        if options[:release_lock_uri]
          uri = options[:release_lock_uri]
        else
          raise 'Insufficient arguments' unless options[:pipeline_name]
          uri = "#{@base_uri}/api/pipelines/#{options[:pipeline_name]}/releaseLock"
        end
        @http_fetcher.post!(uri)
      end

      # This API provides the ability to pause a pipeline.
      def pause(options = {})
        options = ({:pause_uri => nil, :pipeline_name => nil}).merge(options)
        if options[:pause_uri]
          uri = options[:pause_uri]
        else
          raise 'Insufficient arguments' unless options[:pipeline_name]
          uri = "#{@base_uri}/api/pipelines/#{options[:pipeline_name]}/pause"
        end
        @http_fetcher.post!(uri)
      end

      # This API provides the ability to unpause a pipeline.
      def unpause(options={})
        options = ({:unpause_uri => nil, :pipeline_name => nil}).merge(options)
        if options[:unpause_uri]
          uri = options[:unpause_uri]
        else
          raise 'Insufficient arguments' unless options[:pipeline_name]
          uri = "#{@base_uri}/api/pipelines/#{options[:pipeline_name]}/unpause"
        end
        @http_fetcher.post!(uri)
      end

      def pipeline(options = {})
        options = ({:pipeline_uri => nil, :pipeline_name => nil, :pipeline_id => nil, :eager_parser => []}).merge(options)
        if options[:pipeline_uri]
          uri = options[:pipeline_uri]
        else
          raise 'Insufficient arguments' unless options[:pipeline_name] && options[:pipeline_id]
          uri = "#{@base_uri}/api/pipelines/#{options[:pipeline_name]}/#{options[:pipeline_id]}.xml"
        end
        pipeline = GoApiClient::Parsers::Pipeline.parse(Nokogiri::XML(@http_fetcher.get!(uri)).root)
        @pipeline_cache[GoApiClient::Domain::InternalCache.new(pipeline.self_uri, options)] ||= pipeline
        if options[:eager_parser] && options[:eager_parser].include?(:stage)
          stage_api = GoApiClient::Api::Stage.new(@base_uri, @http_fetcher, {:pipeline_cache => @pipeline_cache, :stage_cache => @stage_cache})
          pipeline.parsed_stages = pipeline.stages.collect do |stage_uri|
            stage = @stage_cache[GoApiClient::Domain::InternalCache.new(stage_uri, options)] || stage_api.stage(options.merge({:stage_uri => stage_uri}))
            @stage_cache[GoApiClient::Domain::InternalCache.new(stage_uri, options)] ||= stage
            stage
          end
        end
        pipeline
      end
    end
  end
end