require 'nokogiri'

module GoApiClient
  module Api
    class Cctray < GoApiClient::Api::AbstractApi

      def initialize(attributes = {})
        super(attributes)
        @cctray_uri = "#{@base_uri}/cctray.xml"
      end

      def projects(options={})
        options = ({:pipeline_name => nil, :stage_name => nil, :job_name => nil, :activity => nil, :web_uri => nil, :eager_parser => []}).merge(options)

        name_args = []
        name_args << "starts-with(@name, '#{options[:pipeline_name]}')" if  options[:pipeline_name]
        name_args << "starts-with(substring-after(@name, ' :: '), '#{options[:stage_name]}')" if options[:stage_name]
        name_args << "starts-with(substring-after(substring-after(@name, ' :: '), ' :: '), '#{options[:job_name]}')" if options[:job_name]

        xpath_args = []
        xpath_args << name_args.join(' and ') unless name_args.empty?
        xpath_args << "@activity='#{options[:activity]}'" if options[:activity]
        xpath_args << "@webUrl='#{options[:web_uri]}'" if options[:web_uri]

        xpath_str = './Project'
        unless xpath_args.empty?
          xpath_str = "#{xpath_str}[#{xpath_args.join(' and ')}]"
        end

        doc = Nokogiri::XML(@http_fetcher.get!(@cctray_uri))
        if doc.root
          if options[:eager_parser] && options[:eager_parser].include?(:stage)
            stage_api = GoApiClient::Api::Stage.new({:base_uri => @base_uri, :http_fetcher => @http_fetcher})
          end

          doc.root.xpath(xpath_str).collect do |element|
            project = GoApiClient::Parsers::Project.parse(element)
            project.parsed_pipeline_name, project.parsed_stage_name, project.parsed_job_name = project.name.split('::').map(&:strip)
            if options[:eager_parser] && options[:eager_parser].include?(:stage) && ! project.parsed_job_name
              project.parsed_stage = stage_api.stage(options.merge({:stage_uri => "#{project.web_uri}.xml"}))
            end
            project
          end
        else
          []
        end
      end

      private
      attr_reader :cctray_uri
    end
  end
end