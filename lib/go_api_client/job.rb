module GoApiClient
  class Job
    attr_accessor :artifacts_uri, :console_log_url, :url, :http_fetcher

    PROPERTIES = {
      :duration   => :cruise_job_duration,
      :result     => :cruise_job_result,
      :scheduled  => :cruise_timestamp_01_scheduled,
      :assigned   => :cruise_timestamp_02_assigned,
      :preparing  => :cruise_timestamp_03_preparing,
      :building   => :cruise_timestamp_04_building,
      :completing => :cruise_timestamp_05_completing,
      :completed  => :cruise_timestamp_06_completed,
    }

    attr_accessor *PROPERTIES.keys

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

    def parse!
      self.artifacts_uri = @root.xpath("./artifacts").first.attributes["baseUri"].value
      self.url           = href_from(@root.xpath("./link[@rel='self']"))

      PROPERTIES.each do |variable, property_name|
        property_value = @root.xpath("./properties/property[@name='#{property_name}']").first.content

        if property_name =~ /timestamp/
          property_value = Time.parse(property_value).utc
        elsif property_value =~ /^\d+$/
          property_value = property_value.to_i
        end

        self.send("#{variable}=", property_value)
      end

      @root = nil
      self
    end

    def console_log_url
      @console_log_url ||= "#{artifacts_uri}/cruise-output/console.log"
    end

    private
    def href_from(xml)
      xml.first.attribute('href').value unless xml.empty?
    end
  end
end
