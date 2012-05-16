module GoApiClient
  class Commit

    attr_accessor :revision, :message, :time, :user

    include GoApiClient::Helpers::SimpleAttributesSupport

    def initialize(root, attributes={})
      @root = root
      super(attributes)
    end

    def parse!
      self.revision = @root.xpath("./revision").first.content
      self.message  = @root.xpath("./message").first.content
      self.time     = Time.parse(@root.xpath("./checkinTime").first.content).utc
      self.user     = User.parse(@root.xpath("./user").first.content)
      @root         = nil
      self
    end

    def to_s
"commit #{revision}
Author: #{user}
Date:   #{time}

#{message.each_line.collect {|l| "    #{l}"}}"
    end
  end
end
