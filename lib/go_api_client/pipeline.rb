module GoApiClient
  class Pipeline
    attr_accessor :url, :id, :commits, :label, :authors, :stages

    def initialize(url)
      @url = url
      @stages = []
    end

    def fetch
      doc = Nokogiri::XML(open(self.url))
      @label = doc.root.attributes["label"].value
      @id = doc.root.xpath("./id").first.content
      @commits = doc.root.xpath("./materials/material/modifications/changeset").collect do |changeset|
        Commit.new(changeset).parse!
      end
      self
    end

    def authors
      @authors ||= stages.first.authors
    end

  end
end
