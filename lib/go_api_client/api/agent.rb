require 'json'

module GoApiClient
  module Api
    class Agent < GoApiClient::Api::AbstractApi

      def initialize(attributes = {})
        super(attributes)
        @agent_uri = "#{@base_uri}/api/agents"
        @agent_headers = {
          'Content-Type' => 'application/json',
          'Accept'       => 'application/vnd.go.cd.v1+json'
        }
      end

      def agents(options={})
        options = ({:uuid => nil}).merge(options)
        uri = options[:uuid] ? "#{@agent_uri}/#{options[:uuid]}" : @agent_uri

        response = JSON.parse(@http_fetcher.get!(uri, {:headers=>@agent_headers}))
        if response['_embedded']
          response['_embedded']['agents'].map do |agent_hash|
            agent_hash.delete('_links')
            GoApiClient::Domain::Agent.new(agent_hash)
          end
        else
          response.delete('_links')
          GoApiClient::Domain::Agent.new(response)
        end
      end

      #
      # API available since v15.2.0
      #
      # Possible options:
      # * hostname  String  The new hostname.
      # * resources String | Array  A comma separated strings of resources, or an array of string resources.
      # * enabled Boolean Whether an agent should be enabled. In case of agents awaiting approval, setting this will approve the agents.
      #
      def update(uuid, options={})
        uri = "#{@agent_uri}/#{uuid}"
        response = JSON.parse(@http_fetcher.patch!(uri, {:headers=>@agent_headers, :params=>options}))
        response.delete('_links')
        GoApiClient::Domain::Agent.new(response)
      end

      def enable(uuid)
        update(uuid, {:enabled => true})
      end

      def disable(uuid)
        update(uuid, {:enabled => false})
      end

      def delete(uuid)
        uri = "#{@agent_uri}/#{uuid}"
        @http_fetcher.delete!(uri, {:headers=>@agent_headers})
        true
      end

      private
      attr_reader :agents_uri
    end
  end
end