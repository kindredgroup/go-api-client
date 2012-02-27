module GoApiClient
  class Job
    attr_reader :artifacts_uri, :console_log_url
    
    def self.build(stage, links)
      @stage = stage
      links.collect do |link|
        job = Nokogiri::XML(open(link))
        self.new(job.xpath("//artifacts").first.attributes["baseUri"].value)
      end
    end

    def initialize(artifacts_uri)
      @artifacts_uri = artifacts_uri
      @console_log_url = "#{artifacts_uri}/cruise-output/console.log"
    end
  end
end
