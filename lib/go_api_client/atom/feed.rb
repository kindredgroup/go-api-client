module GoApiClient
  module Atom
    class Feed
      attr_accessor :updated_at
      attr_accessor :next_page
      attr_accessor :url
      attr_accessor :entries

      def initialize(root)
        @root = root
      end

      def parse!
        self.updated_at = @root.xpath('xmlns:updated').first.content
        self.next_page  = @root.xpath("xmlns:link[@rel='next']").first.attribute('href').value
        self.url        = @root.xpath("xmlns:link[@rel='self']").first.attribute('href').value

        self.entries    = @root.xpath("xmlns:entry").collect do |entry|
          Entry.new(entry).parse!
        end
        self
      end

    end
  end


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

  class Pipeline
    attr_reader :details_link, :id, :commit_messages
    attr_accessor :stages

    def initialize(details_link)
      @details_link = details_link
      @stages = []
    end

    def fetch
      doc = Nokogiri::XML(open(self.details_link))
      @label = doc.root.attributes["label"].value
      @id = doc.root.xpath("//id").first.content
      @commit_messages = doc.root.xpath("//message").map(&:content)
      self
    end

    def authors
      authors = stages.map(&:authors).flatten
      authors.map(&:name).flatten.uniq.join(" ,")
    end
    
    def same?(link)
      @details_link == link
    end
  end
end
