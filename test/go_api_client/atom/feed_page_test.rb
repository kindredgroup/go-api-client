require "test_helper"

module GoApiClient
  module Atom
    class FeedPageTest < Test::Unit::TestCase

      setup do
        doc = Nokogiri::XML(file_contents("pagination/stages.xml"))
        @feed_page = FeedPage.new(doc.root).parse!
      end

      test "should be able to parse one page of the paginated Go atom feed" do
        assert_equal 25, @feed_page.entries.count
        assert_equal 'https://go-server.example.com/go/api/pipelines/tlb/stages.xml', @feed_page.url
        assert_equal 'https://go-server.example.com/go/api/pipelines/tlb/stages.xml?before=7959831', @feed_page.next_page
        assert_equal Time.parse('2012-04-17 10:56:53 UTC'), @feed_page.updated_at
      end

      test "should answer if an entry id is present in the feed page" do
        assert @feed_page.contains_entry?(@feed_page.entries[5].id)
        assert_false @feed_page.contains_entry?("foo")
      end

      test "should answer if an entry object is present in the feed page" do
        assert @feed_page.contains_entry?(@feed_page.entries[5])
        assert_false @feed_page.contains_entry?(Entry.new(nil))
      end

      test "should return entries after a particular entry (top entries in feed)" do
        entry = @feed_page.entries[5]

        assert_equal @feed_page.entries_after(entry.id), @feed_page.entries_after(entry)

        assert_equal 5, @feed_page.entries_after(entry.id).count
        assert_equal 5, @feed_page.entries_after(entry).count

        assert_false @feed_page.entries_after(entry).include?(entry)
      end
    end
  end
end
