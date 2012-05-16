require 'time'
module GoApiClient
  class Stage
    attr_accessor :authors, :url, :name, :result, :jobs, :pipeline, :completed_at, :pipeline_cache

    include GoApiClient::Helpers::SimpleAttributesSupport

    def initialize(root, attributes={})
      @root = root
      super(attributes)
    end

    class << self
      def from(url, attributes = {})
        doc = Nokogiri::XML(open(url))
        self.new(doc.root, attributes).parse!
      end
    end

    def parse!
      @name = @root.xpath("@name").first.value
      @url  = href_from(@root.xpath("./link[@rel='self']"))
      @result = @root.xpath("./result").first.content
      @completed_at = Time.parse(@root.xpath("./updated").first.content).utc
      job_urls = @root.xpath("./jobs/job").collect{|job| job.attributes["href"].value}
      @jobs = Job.build(self, job_urls)

      pipeline_link = @root.xpath("./pipeline").first.attributes["href"].value

      pipeline = @pipeline_cache[pipeline_link] || Pipeline.from(pipeline_link)
      pipeline.stages << self

      @pipeline_cache[pipeline_link] ||= pipeline
      self
    end

    private
    def href_from(xml)
      xml.first.attribute('href').value unless xml.empty?
    end

  end
end

