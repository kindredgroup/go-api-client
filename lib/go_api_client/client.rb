module GoApiClient
  class Client
    # Constructor
    #
    # @option options [String]  :host ("localhost") Host to connect to.
    # @option options [Ingeger] :port (8153) Port to connect to.
    # @option options [Boolean] :ssl  (false) If connection should be made over ssl.
    # @option options [String]  :username (nil) The username to be used if server or the pipeline requires authorization.
    # @option options [String]  :password (nil) The password to be used if server or the pipeline requires authorization.
    def initialize(options={})
      options = ({:ssl => false, :host => 'localhost', :port => 8153, :username => nil, :password => nil}).merge(options)
      @http_fetcher = GoApiClient::HttpFetcher.new(:username => options[:username], :password => options[:password])
      @base_uri = "#{options[:ssl] ? 'https' : 'http'}://#{options[:host]}:#{options[:port]}/go"
    end

    def api(name)
      class_name = name.slice(0, 1).capitalize + name.slice(1..-1)
      api_class = Object.const_get("#{self.class.to_s.split("::").first}::Api::#{class_name}")
      api_class.new(@base_uri, @http_fetcher)
    end
  end
end