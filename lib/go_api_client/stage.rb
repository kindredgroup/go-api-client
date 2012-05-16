require 'time'
module GoApiClient
  class Stage
    attr_accessor :authors, :url, :name, :result, :jobs, :pipeline, :completed_at

    def initialize(entry, pipelines)
      @authors = entry.authors
      @url = entry.stage_href
      @pipelines = pipelines
    end

    # FIXME: remove this
    def fetch
      doc = Nokogiri::XML(open(self.url))
      root = doc.root
      @name = root.xpath("@name").first.value
      @result = root.xpath("./result").first.content
      @completed_at = Time.parse(root.xpath("./updated").first.content).utc
      job_urls = root.xpath("./jobs/job").collect{|job| job.attributes["href"].value}
      @jobs = Job.build(self, job_urls)

      pipeline_link = root.xpath("./pipeline").first.attributes["href"].value

      pipeline = @pipelines[pipeline_link] || Pipeline.new(pipeline_link).fetch
      pipeline.stages << self

      @pipelines[pipeline_link] ||= pipeline
      self
    end
  end
end

