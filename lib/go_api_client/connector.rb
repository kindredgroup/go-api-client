module GoApiClient
  class Connector
    attr_reader :stages
    def initialize(options_hsh)
      @options = ({:protocol => 'http',
                   :port => 8153,
                   :username => nil,
                   :password => nil,
                   :stop_at => nil,
                   :pipeline_name => 'defaultPipeline'})
      .merge(options_hsh)
      @pipelines = Hash.new
      self
    end

    def connect!
      @http_fetcher = GoApiClient::HttpFetcher.new(:username => @options[:username], :password => @options[:password])
      @feed = fetch_feed
      @stages = @feed.entries.collect do |entry|
        Stage.from(entry.stage_href, :authors => entry.authors, :pipeline_cache => @pipelines, :http_fetcher => @http_fetcher)
      end
      self
    end


    private
    def fetch_feed
      feed_url = "#{@options[:protocol]}://#{@options[:host]}:#{@options[:port]}/go/api/pipelines/#{@options[:pipeline_name]}/stages.xml"
      feed = GoApiClient::Atom::Feed.new(feed_url, @options[:stop_at])
      feed.fetch!(@http_fetcher)
    end
  end
end
