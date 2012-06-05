require "test_helper"

module GoApiClient
  module Atom
    class FeedTest < Test::Unit::TestCase
      setup do
        stub_request(:get, "https://go-server.example.com/go/api/pipelines/tlb/stages.xml").to_return(:body => file_contents("pagination/stages.xml"))
        stub_request(:get, "https://go-server.example.com/go/api/pipelines/tlb/stages.xml?before=7959831").to_return(:body => file_contents("pagination/stages_before_7959831.xml"))
      end

      test "should stop at last seen atom entry id" do
        feed = GoApiClient::Atom::Feed.new('https://go-server.example.com/go/api/pipelines/tlb/stages.xml', 'https://go-server.example.com/go/pipelines/tlb/175/ant_count_tlb/1').fetch!
        assert_equal (25+4), feed.entries.count
      end

      test "should stop at first page if entry id not specified" do
        stub_request(:get, "https://go-server.example.com/go/api/pipelines/tlb/stages.xml?before=7916973").to_return(:body => file_contents("pagination/stages_before_7916973.xml"))

        feed = GoApiClient::Atom::Feed.new('https://go-server.example.com/go/api/pipelines/tlb/stages.xml').fetch!
        assert_equal 25*3, feed.entries.count
      end

    end
  end
end
