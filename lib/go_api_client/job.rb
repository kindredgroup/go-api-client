module GoApiClient
  class Job
    attr_accessor :artifacts_uri, :console_log_url, :url

    include GoApiClient::Helpers::SimpleAttributesSupport

    def initialize(root, attributes={})
      @root = root
      super(attributes)
    end

    class << self
      def from(url, attributes={})
        attributes[:http_fetcher] ||= GoApiClient::HttpFetcher.new
        doc = Nokogiri::XML(attributes.delete(:http_fetcher).get_response_body(url))
        self.new(doc.root, attributes).parse!
      end
    end

    def parse!
      self.artifacts_uri = @root.xpath("./artifacts").first.attributes["baseUri"].value
      self.url           = href_from(@root.xpath("./link[@rel='self']"))

      @root = nil
      self
    end

    def console_log_url
      @console_log_url ||= "#{artifacts_uri}/cruise-output/console.log"
    end

    private
    def href_from(xml)
      xml.first.attribute('href').value unless xml.empty?
    end
  end
end
