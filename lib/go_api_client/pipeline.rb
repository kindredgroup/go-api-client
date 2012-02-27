module GoApiClient
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
