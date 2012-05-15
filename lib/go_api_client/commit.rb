module GoApiClient
  class Commit

    attr_accessor :revision, :message, :time, :user

    def initialize(root)
      @root = root
    end
    
    def parse!
      @revision = @root.xpath("//revision").first.content
      @message  = @root.xpath("//message").first.content
      @time     = Time.parse(@root.xpath("//checkinTime").first.content).utc
      @user     = User.parse(@root.xpath("//user").first.content)
      self
    end
  end
end
