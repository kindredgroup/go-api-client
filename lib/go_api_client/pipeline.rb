module GoApiClient
  class Pipeline
    attr_accessor :url, :id, :commits, :label, :authors, :stages

    include GoApiClient::Helpers::SimpleAttributesSupport

    def initialize(root, attributes={})
      @root = root
      super(attributes)
    end

    class << self
      def from(url)
        doc = Nokogiri::XML(open(url))
        self.new(doc.root).parse!
      end
    end

    def stages
      @stages ||= []
    end

    def parse!
      @label = @root.attributes["label"].value
      @id = @root.xpath("./id").first.content
      @commits = @root.xpath("./materials/material/modifications/changeset").collect do |changeset|
        Commit.new(changeset).parse!
      end
      @root = nil
      self
    end

    def authors
      @authors ||= stages.first.authors
    end

  end
end
