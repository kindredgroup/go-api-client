module GoApiClient
  module Atom
    class Feed
      attr_accessor :feed_pages, :entries

      def initialize(atom_feed_url, last_entry_id=nil)
        @atom_feed_url = atom_feed_url
        @last_entry_id = last_entry_id
      end

      def fetch!
        self.entries = []
        feed_url = @atom_feed_url

        begin
          doc = Nokogiri::XML(open(feed_url))
          feed_page = GoApiClient::Atom::FeedPage.new(doc.root).parse!

          self.entries += if feed_page.contains_entry?(@last_entry_id)
                            feed_page.entries_after(@last_entry_id)
                          else
                            feed_page.entries
                          end
          feed_url = feed_page.next_page
        end while feed_page.next_page && !feed_page.contains_entry?(@last_entry_id)
      end
    end
  end
end
