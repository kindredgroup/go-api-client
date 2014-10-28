module GoApiClient
  class Client
    def initialize(options={})
      options = ({:uri => nil, :username => nil, :password => nil, :ssl_verify_mode => nil}).merge(options)
      @http_fetcher = GoApiClient::HttpFetcher.new(options)
      if options[:uri]
        @base_uri = options[:uri].chomp('/')
      else
        options = ({:host => 'localhost', :port => 8153, :ssl => false}).merge(options)
        @base_uri = "#{options[:ssl] ? 'https' : 'http'}://#{options[:host]}:#{options[:port]}/go"
      end
    end

    def api(name, options={})
      class_name = name.slice(0, 1).capitalize + name.slice(1..-1)
      api_class = "#{self.class.to_s.split('::').first}::Api::#{class_name}".split('::').inject(Object) { |n, c| n.const_get c }
      api_class.new({:base_uri => @base_uri, :http_fetcher => @http_fetcher}.merge(options))
    end
  end
end