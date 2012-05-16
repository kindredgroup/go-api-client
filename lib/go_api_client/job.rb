module GoApiClient
  class Job
    attr_accessor :artifacts_uri, :console_log_url

    def self.build(stage, links)
      @stage = stage
      links.collect do |link|
        doc = Nokogiri::XML(open(link))
        root = doc.root
        self.new(root.xpath("./artifacts").first.attributes["baseUri"].value)
      end
    end

    def initialize(artifacts_uri)
      @artifacts_uri = artifacts_uri
      @console_log_url = "#{artifacts_uri}/cruise-output/console.log"
    end
  end
end
