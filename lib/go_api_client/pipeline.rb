module GoApiClient
  class Pipeline
    attr_accessor :details_link, :id, :commit_messages, :label, :authors, :stages

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
      @authors ||= stages.first.authors
    end

  end
end
