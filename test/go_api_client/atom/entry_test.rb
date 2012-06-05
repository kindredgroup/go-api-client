require "test_helper"

module GoApiClient
  module Atom
    class EntryTest < Test::Unit::TestCase
      setup do
        doc = Nokogiri::XML(file_contents('pagination/stages.xml'))
        @root = doc.root
        @entry_node = @root.xpath('./xmlns:entry')[12]
      end

      test "should parse entry node" do
        entry = Entry.new(@entry_node).parse!
        assert_equal 'https://go-server.example.com/go/pipelines/tlb/177/ant_count_go/1', entry.id
        assert_equal Time.parse('2012-01-22 11:32:57 UTC'), entry.updated_at
        assert_equal 'tlb(177) stage ant_count_go(1) Passed', entry.title
        assert_equal 'https://go-server.example.com/go/api/stages/210161.xml', entry.stage_href
        expected_authors = [
          Author.new(nil, :name => 'Pavan', :email => 'itspanzi@gmail.com'),
          Author.new(nil, :name => 'Pavan Sudarshan', :email => 'itspanzi@gmail.com')
        ]

        assert_equal expected_authors, entry.authors
      end
    end
  end
end
