module GoApiClient
  class Pipeline
    attr_accessor :details_link, :id, :commits, :label, :authors, :stages

    def initialize(details_link)
      @details_link = details_link
      @stages = []
    end

    def fetch
      doc = Nokogiri::XML(open(self.details_link))
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
