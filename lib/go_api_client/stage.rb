module GoApiClient
  class Stage
    attr_reader :authors, :details_link, :name, :result

    def initialize(entry, pipelines)
      @authors = entry.authors
      @details_link = entry.stage_href
      @pipelines = pipelines
    end

    def fetch
      doc = Nokogiri::XML(open(self.details_link))
      @name = doc.root.xpath("@name").first.value
      @result = doc.root.xpath("//result").first.content

      pipeline_link = doc.root.xpath("//pipeline").first.attributes["href"].value
      existing_pipeline =  @pipelines.find {|p| p.same?(pipeline_link)}
      
      if existing_pipeline
        existing_pipeline.stages << self
      else
        new_pipeline = Pipeline.new(pipeline_link).fetch
        new_pipeline.stages << self
        @pipelines << new_pipeline
      end
      @pipelines
    end
  end
end
