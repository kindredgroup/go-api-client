module GoApiClient
  module Atom
    class Feed
      attr_accessor :updated_at
      attr_accessor :next_page
      attr_accessor :url
      attr_accessor :entries

      def initialize(root)
        @root = root
      end

      def parse!
        self.updated_at = @root.xpath('xmlns:updated').first.content
        self.next_page  = @root.xpath("xmlns:link[@rel='next']").first.attribute('href').value
        self.url        = @root.xpath("xmlns:link[@rel='self']").first.attribute('href').value

        self.entries    = @root.xpath("xmlns:entry").collect do |entry|
          Entry.new(entry).parse!
        end
        self
      end
    end
  end
end
