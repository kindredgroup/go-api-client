module GoApiClient
  class Pipeline
    attr_accessor :url, :commits, :label, :counter, :authors, :stages, :name, :http_fetcher, :identifier, :schedule_time

    include GoApiClient::Helpers::SimpleAttributesSupport

    def initialize(root, attributes={})
      @root = root
      super(attributes)
    end

    class << self
      def from(url, attributes = {})
        attributes[:http_fetcher] ||= GoApiClient::HttpFetcher.new
        doc = Nokogiri::XML(attributes[:http_fetcher].get_response_body(url))
        self.new(doc.root, attributes).parse!
      end
    end

    def stages
      @stages ||= []
    end

    def parse!
      self.name       = @root.attributes["name"].value
      self.label      = @root.attributes["label"].value
      self.counter    = @root.attributes["counter"].value.to_i
      self.url        = href_from(@root.xpath("./link[@rel='self']"))
      self.identifier = @root.xpath("./id").first.content
      self.schedule_time = Time.parse(@root.xpath('./scheduleTime').first.content).utc
      self.commits    = @root.xpath("./materials/material/modifications/changeset").collect do |changeset|
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
