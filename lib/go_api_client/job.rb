module GoApiClient
  class Job
    attr_accessor :artifacts_uri, :console_log_url

    include GoApiClient::Helpers::SimpleAttributesSupport

    def initialize(root, attributes={})
      @root = root
      super(attributes)
    end

    class << self
      def from(url)
        doc = Nokogiri::XML(open(url))
        self.new(doc.root).parse!
      end
    end

    def parse!
      self.artifacts_uri = @root.xpath("./artifacts").first.attributes["baseUri"].value
      @root = nil
      self
    end

    def console_log_url
      @console_log_url ||= "#{artifacts_uri}/cruise-output/console.log"
    end

  end
end
