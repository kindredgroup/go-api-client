require 'time'
module GoApiClient
  class Stage
    attr_accessor :authors, :stage_link, :name, :result, :jobs, :pipeline, :completed_at

    def initialize(entry, pipelines)
      @authors = entry.authors
      @stage_link = entry.stage_href
      @pipelines = pipelines
    end

    def fetch
      doc = Nokogiri::XML(open(self.stage_link))
      root = doc.root
      @name = root.xpath("@name").first.value
      @result = root.xpath("./result").first.content
      @completed_at = Time.parse(root.xpath("./updated").first.content).utc
      job_detail_links = root.xpath("./jobs/job").collect{|job| job.attributes["href"].value}
      @jobs = Job.build(self, job_detail_links)

      pipeline_link = root.xpath("./pipeline").first.attributes["href"].value

      pipeline = @pipelines[pipeline_link] || Pipeline.new(pipeline_link).fetch
      pipeline.stages << self

      @pipelines[pipeline_link] ||= pipeline
      self
    end
  end
end

