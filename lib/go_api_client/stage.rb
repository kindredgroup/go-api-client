require 'time'
module GoApiClient
  class Stage
    attr_accessor :authors, :url, :name, :result, :jobs, :pipeline, :completed_at, :pipeline_cache, :http_fetcher, :counter, :identifier

    include GoApiClient::Helpers::SimpleAttributesSupport

    def initialize(root, attributes={})
      @root = root
      super(attributes)
    end

    class << self
      def from(url, attributes = {})
        attributes[:http_fetcher] ||= GoApiClient::HttpFetcher.new
        doc = Nokogiri::XML(attributes[:http_fetcher].get!(url))
        self.new(doc.root, attributes).parse!
      end
    end

    def parse!
      self.name         = @root.attributes['name'].value
      self.counter      = @root.attributes['counter'].value.to_i
      self.url          = href_from(@root.xpath("./link[@rel='self']"))
      self.result       = @root.xpath("./result").first.content
      self.completed_at = Time.parse(@root.xpath("./updated").first.content).utc
      self.jobs         = @root.xpath("./jobs/job").collect do |job_element|
                            Job.from(job_element.attributes["href"].value, :http_fetcher => http_fetcher)
                          end
      self.identifier   = @root.xpath('./id').first.content

      pipeline_link     = @root.xpath("./pipeline").first.attributes["href"].value

      pipeline = @pipeline_cache[pipeline_link] || Pipeline.from(pipeline_link, :http_fetcher => http_fetcher)
      pipeline.stages << self

      self.pipeline_cache[pipeline_link] ||= pipeline
      @root = nil
      self
    end

    def failed?
      "Failed" == @result
    end

    def passed?
      !failed?
    end

    private
    def href_from(xml)
      xml.first.attribute('href').value unless xml.empty?
    end

  end
end

