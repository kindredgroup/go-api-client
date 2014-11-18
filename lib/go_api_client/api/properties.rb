require 'csv'

module GoApiClient
  module Api
    class Properties < GoApiClient::Api::AbstractApi

      def initialize(attributes = {})
        super(attributes)
      end

      def properties(options = {})
        options = ({:properties_uri => nil, :pipeline_name => nil, :pipeline_counter => nil, :stage_name => nil, :stage_counter => nil, :job_name => nil, :property_name => nil}).merge(options)
        if options[:properties_uri]
          uri = options[:properties_uri]
        else
          raise 'Insufficient arguments' unless options[:pipeline_name] && options[:pipeline_counter] && options[:stage_name] && options[:stage_counter] && options[:job_name]
          uri = "#{@base_uri}/properties/#{options[:pipeline_name]}/#{options[:pipeline_counter]}/#{options[:stage_name]}/#{options[:stage_counter]}/#{options[:job_name]}" + (options[:property_name] ? "/#{options[:property_name]}" : '')
        end

        begin
          body = @http_fetcher.get!(uri)
        rescue GoApiClient::HttpFetcher::HttpError
          # ignore, error message will be logged
        end

        body ? CSV.new(body, :headers => true).to_a.map { |row| row.to_hash } : []
      end

      def create_property(options = {})
        options = ({:properties_uri => nil, :pipeline_name => nil, :pipeline_counter => nil, :stage_name => nil, :stage_counter => nil, :job_name => nil, :property_name => nil, :property_value => nil}).merge(options)
        if options[:properties_uri]
          uri = options[:properties_uri]
        else
          raise 'Insufficient arguments' unless options[:pipeline_name] && options[:pipeline_counter] && options[:stage_name] && options[:stage_counter] && options[:job_name] && options[:property_name] && options[:property_value]
          uri = "#{@base_uri}/properties/#{options[:pipeline_name]}/#{options[:pipeline_counter]}/#{options[:stage_name]}/#{options[:stage_counter]}/#{options[:job_name]}/#{options[:property_name]}"
        end

        response_body = @http_fetcher.post!(uri, {:params => {:value => options[:property_value]}})
        response_body == "Property '#{options[:property_name]}' created with value '#{options[:property_value]}'" ? true : false
      end
    end
  end
end