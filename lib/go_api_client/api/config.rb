require 'nokogiri'

module GoApiClient
  module Api
    class Config < GoApiClient::Api::AbstractApi

      def initialize(attributes = {})
        super(attributes)
      end

      def templates(options={})
        options = ({:template_name => nil, :config_uri => nil}).merge(options)
        uri = options[:config_uri] ? options[:config_uri] : "#{@base_uri}/api/admin/config.xml"

        xpath_str = './templates/pipeline' + (options[:template_name] ? "[@name='#{options[:template_name]}']" : '')
        doc = Nokogiri::XML(@http_fetcher.get!(uri)).remove_namespaces!
        if doc.root
          doc.root.xpath(xpath_str).collect do |element|
            GoApiClient::Parsers::Config::Pipeline.parse(element)
          end
        else
          []
        end
      end

      def pipelines(options={})
        options = ({:group_name => nil, :pipeline_name => nil, :config_uri => nil, :eager_parser => []}).merge(options)
        uri = options[:config_uri] ? options[:config_uri] : "#{@base_uri}/api/admin/config.xml"

        group_args = []
        group_args << "@group='#{options[:group_name]}'" if options[:group_name]

        pipeline_args= []
        pipeline_args << "@name='#{options[:pipeline_name]}'" if options[:pipeline_name]

        xpath_args = []
        xpath_args << (group_args.empty? ? 'pipelines' : "pipelines[#{group_args.join(' and ')}]")
        xpath_args << (pipeline_args.empty? ? 'pipeline' : "pipeline[#{pipeline_args.join(' and ')}]")

        xpath_str = './'
        unless xpath_args.empty?
          xpath_str = "#{xpath_str}#{xpath_args.join('/')}"
        end

        doc = Nokogiri::XML(@http_fetcher.get!(uri)).remove_namespaces!
        if doc.root
          doc.root.xpath(xpath_str).collect do |element|
            pipeline = GoApiClient::Parsers::Config::Pipeline.parse(element)
            if options[:eager_parser] && options[:eager_parser].include?(:template) && pipeline.template
              pipeline.parsed_template = templates(options.merge({:template_name => pipeline.template}))
            end
            pipeline
          end
        else
          []
        end
      end
    end
  end
end
