module GoApiClient
  module Atom
    class Feed
      attr_accessor :updated_at, :next_page, :url, :entries

      def initialize(root)
        @root = root
      end

      def parse!
        self.updated_at = @root.xpath('xmlns:updated').first.content
        self.next_page  = href_from(@root.xpath("xmlns:link[@rel='next']"))
        self.url        = href_from(@root.xpath("xmlns:link[@rel='self']"))
        self.entries    = @root.xpath("xmlns:entry").collect do |entry|
          Entry.new(entry).parse!
        end
        self
      end

      def href_from(xml)
        xml.first.attribute('href').value unless xml.empty?
      end
    end
  end
end
