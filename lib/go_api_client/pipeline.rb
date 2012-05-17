module GoApiClient
  class Pipeline
    attr_accessor :url, :id, :commits, :label, :authors, :stages, :name

    include GoApiClient::Helpers::SimpleAttributesSupport

    def initialize(root, attributes={})
      @root = root
      super(attributes)
    end

    class << self
      def from(url, attributes={})
        attributes[:http_fetcher] ||= GoApiClient::HttpFetcher.new
        doc = Nokogiri::XML(attributes.delete(:http_fetcher).get_response_body(url))
        self.new(doc.root, attributes).parse!
      end
    end

    def stages
      @stages ||= []
    end

    def parse!
      self.name     = @root.attributes["name"].value
      self.label    = @root.attributes["label"].value
      self.url      = href_from(@root.xpath("./link[@rel='self']"))
      self.id       = @root.xpath("./id").first.content
      self.commits  = @root.xpath("./materials/material/modifications/changeset").collect do |changeset|
                        Commit.new(changeset).parse!
                      end
      @root = nil
      self
    end

    def authors
      @authors ||= stages.first.authors
    end

    private
    def href_from(xml)
      xml.first.attribute('href').value unless xml.empty?
    end

  end
end
