require 'time'
module GoApiClient
  module Atom
    class FeedPage
      attr_accessor :updated_at, :next_page, :url, :entries

      include GoApiClient::Helpers::SimpleAttributesSupport

      def initialize(root, attributes={})
        @root = root
        super(attributes)
      end

      def parse!
        self.updated_at = Time.parse(@root.xpath('xmlns:updated').first.content).utc
        self.next_page  = href_from(@root.xpath("xmlns:link[@rel='next']"))
        self.url        = href_from(@root.xpath("xmlns:link[@rel='self']"))
        self.entries    = @root.xpath("xmlns:entry").collect do |entry|
          Entry.new(entry).parse!
        end
        @root = nil
        self
      end

      def entries_after(entry_or_id)
        index = if entry_or_id.is_a?(String)
                  entries.find_index {|e| e.id == entry_or_id}
                else
                  entries.find_index {|e| e == entry_or_id}
                end

        entries[0..index-1]
      end

      def contains_entry?(entry_or_id)
        if entry_or_id.is_a?(String)
          entries.find {|e| e.id == entry_or_id}
        else
          entries.include?(entry_or_id)
        end
      end

      private
      def href_from(xml)
        xml.first.attribute('href').value unless xml.empty?
      end
    end
  end
end
