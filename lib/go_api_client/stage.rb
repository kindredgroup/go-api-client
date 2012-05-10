module GoApiClient
  class Stage
    attr_accessor :authors, :stage_link, :name, :result, :jobs, :pipeline

    def initialize(entry, pipelines)
      @authors = entry.authors
      @stage_link = entry.stage_href
      @pipelines = pipelines
    end

    def fetch
      doc = Nokogiri::XML(open(self.stage_link))
      @name = doc.root.xpath("@name").first.value
      @result = doc.root.xpath("//result").first.content
      job_detail_links = doc.root.xpath("//job").collect{|job| job.attributes["href"].value}
      @jobs = Job.build(self, job_detail_links)

      pipeline_link = doc.root.xpath("//pipeline").first.attributes["href"].value

      pipeline = @pipelines[pipeline_link] || Pipeline.new(pipeline_link).fetch
      pipeline.stages << self

      @pipelines[pipeline_link] ||= pipeline
      self
    end
  end
end

